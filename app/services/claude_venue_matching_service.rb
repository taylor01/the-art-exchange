class ClaudeVenueMatchingService
  include ActionView::Helpers::TextHelper

  def initialize
    @client = Anthropic::Client.new(api_key: ENV["ANTHROPIC_API_KEY"])
    @cache = {}
  end

  def find_or_create_venue(venue_name, location, show_date)
    # First check if there's a poster for this exact date
    poster = find_poster_for_date(show_date)
    return poster.venue if poster&.venue

    # Use cache to avoid duplicate API calls
    cache_key = "#{venue_name}|#{location}|#{show_date}"
    return @cache[cache_key] if @cache[cache_key]

    # Get ALL existing venues for this location
    existing_venues = find_existing_venues_for_location(location)
    puts "🔍 Found #{existing_venues.count} existing venues in #{location}"
    existing_venues.each { |v| puts "   - #{v.name}" }

    if existing_venues.any?
      puts "🤖 Asking Claude to research venue matching..."
      # Use Claude API to research venue matching against ALL venues in city
      match_result = research_venue_with_claude(venue_name, location, show_date, existing_venues)
      
      if match_result[:match_found] && match_result[:matched_venue]
        puts "✅ Claude found match: #{match_result[:matched_venue].name} (#{match_result[:confidence]}% confidence)"
        venue = handle_matched_venue(match_result, venue_name, show_date)
        @cache[cache_key] = venue
        return venue
      else
        puts "❌ Claude found no match, creating new venue"
        # Use Claude's reasoning when venues exist but no match found
        claude_reasoning = "Claude consulted: #{match_result[:reasoning] || 'No specific reasoning provided'}"
        venue = create_new_venue(venue_name, location, show_date, claude_reasoning)
        @cache[cache_key] = venue
        return venue
      end
    else
      puts "📍 No existing venues found, creating new venue"
    end

    # No existing venues found, create new venue
    venue = create_new_venue(venue_name, location, show_date)
    @cache[cache_key] = venue
    venue
  end

  def research_venue_with_claude(venue_name, location, show_date, existing_venues)
    prompt = build_venue_research_prompt(venue_name, location, show_date, existing_venues)
    
    begin
      response = @client.messages.create(
        model: "claude-3-haiku-20240307",
        max_tokens: 1000,
        messages: [
          {
            role: "user",
            content: prompt
          }
        ]
      )

      content = response.content[0].text
      puts "\n=== CLAUDE VENUE MATCHING RESPONSE ==="
      puts "Prompt: #{prompt[0..200]}..."
      puts "Response: #{content}"
      puts "=====================================\n"
      
      result = parse_claude_response(content, existing_venues)
      
      # Log the consultation for audit trail
      log_claude_consultation(
        venue: result[:matched_venue],
        original_venue_name: venue_name,
        location: location,
        show_date: show_date,
        prompt: prompt,
        response: response,
        result: result
      )
      
      result
    rescue => e
      Rails.logger.error "Claude API error: #{e.message}"
      {
        match_found: false,
        matched_venue: nil,
        confidence: 0,
        reasoning: "API error: #{e.message}"
      }
    end
  end

  private

  def find_poster_for_date(show_date)
    Poster.find_by(release_date: show_date)
  end

  def find_existing_venues_for_location(location)
    # Parse location to get city and state/region
    city, region = parse_location(location)
    return [] unless city

    # Find venues in the same city/region - be more liberal to catch similar names
    Venue.where(
      "LOWER(city) = ? AND LOWER(administrative_area) = ?",
      city.downcase,
      region.downcase
    ).includes(:venue_names)
  end

  def parse_location(location_string)
    return [nil, nil] unless location_string

    parts = location_string.split(',').map(&:strip)
    case parts.length
    when 2
      [parts[0], parts[1]]
    when 1
      [parts[0], 'Unknown']
    else
      [parts[0], parts[1]]
    end
  end

  def build_venue_research_prompt(venue_name, location, show_date, existing_venues)
    venue_list = existing_venues.map do |venue|
      historical_names = venue.venue_names.map { |vn| "#{vn.name} (#{vn.date_range})" }.join(", ")
      historical_info = historical_names.present? ? " | Historical names: #{historical_names}" : ""
      address_info = venue.full_address.present? ? venue.full_address : "Address unknown"
      capacity_info = venue.capacity.present? ? "#{venue.capacity} capacity" : "Capacity unknown"
      type_info = venue.venue_type.present? ? venue.venue_type.humanize : "Type unknown"
      
      "- ID #{venue.id}: #{venue.name}\n  Address: #{address_info}\n  Type: #{type_info}, #{capacity_info}#{historical_info}"
    end.join("\n\n")

    <<~PROMPT
      I'm researching a historical concert venue to determine if it corresponds to any existing venues in my database, or if it should be added as a new venue.

      Historical venue from setlist: "#{venue_name}"
      Location: #{location}
      Show date: #{show_date}

      Existing venues in my database for this location:
      #{venue_list}

      RESEARCH TASK: Please investigate this venue and determine if it matches any existing venue in my database. Some venues may match existing ones (renamings/rebrandings), while others will be new venues to add.

      Key factors to evaluate:
      1. PHYSICAL ADDRESS - Is this the same building/location as any existing venue?
      2. VENUE TYPE - Nightclubs ≠ Arenas ≠ Amphitheatres ≠ Theaters ≠ Stadiums
      3. CAPACITY/SIZE - Small venues (under 1,000) ≠ Large venues (over 5,000)
      4. TIME PERIOD - Was this venue operating at this location in #{show_date.year}?

      SAME VENUE examples (address/building unchanged):
      - Corporate naming rights: "Verizon Wireless Amphitheatre" → "PNC Music Pavilion" (same address)
      - Sponsor changes: "Fleet Center" → "TD Garden" (same building)
      - Rebranding: venue sold but same physical location

      DIFFERENT VENUE examples (create new venue):
      - Venue demolished, new venue built elsewhere (different addresses)
      - Different building types: nightclub vs arena vs amphitheatre
      - Different capacities: 200-person club vs 15,000-seat arena
      - Different buildings on same campus/area
      - Venue closed, unrelated venue opened later at different location

      DEFAULT: When uncertain, answer "match_found": false. It's better to create a new venue than incorrectly merge different physical locations.

      Respond with ONLY a JSON object in this format:
      {
        "match_found": true/false,
        "matched_venue_id": id_number_or_null,
        "confidence": 0-100,
        "reasoning": "detailed explanation focusing on physical address, venue type, capacity, and time period",
        "current_name": "current venue name if different from setlist name",
        "historical_names": ["array", "of", "historical", "names", "if", "found"],
        "historical_address": "street address of #{venue_name} in #{show_date.year} if determinable, or null"
      }
    PROMPT
  end

  def parse_claude_response(content, existing_venues)
    # Extract JSON from response
    json_match = content.match(/\{.*\}/m)
    return default_no_match_response unless json_match

    data = JSON.parse(json_match[0])
    
    # Find the matched venue if ID provided
    matched_venue = nil
    if data["match_found"] && data["matched_venue_id"]
      matched_venue = existing_venues.find { |v| v.id == data["matched_venue_id"] }
    end

    {
      match_found: data["match_found"] == true,
      matched_venue: matched_venue,
      confidence: data["confidence"].to_i,
      reasoning: data["reasoning"],
      current_name: data["current_name"],
      historical_names: data["historical_names"] || [],
      historical_address: data["historical_address"]
    }
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse Claude response: #{e.message}"
    Rails.logger.error "Response content: #{content}"
    default_no_match_response
  end

  def default_no_match_response
    {
      match_found: false,
      matched_venue: nil,
      confidence: 0,
      reasoning: "Could not parse Claude API response"
    }
  end

  def handle_matched_venue(match_result, original_venue_name, show_date)
    venue = match_result[:matched_venue]
    
    # Update venue with Claude research results
    venue.update!(
      claude_matched: true,
      claude_confidence: match_result[:confidence],
      claude_reasoning: match_result[:reasoning]
    )

    # Add historical name if different
    if original_venue_name != venue.name
      venue.add_historical_name(original_venue_name, show_date)
    end

    # Add any additional historical names discovered by Claude
    if match_result[:historical_names].present?
      match_result[:historical_names].each do |historical_name|
        next if historical_name == venue.name || historical_name == original_venue_name
        
        # Only add if we don't already have this name
        unless venue.venue_names.where(name: historical_name).exists?
          venue.add_historical_name(historical_name, show_date - 1.year)
        end
      end
    end

    # Update current name if Claude suggests it
    if match_result[:current_name].present? && match_result[:current_name] != venue.name
      venue.set_current_name(match_result[:current_name])
    end

    venue.reload
  end

  def create_new_venue(venue_name, location, show_date, claude_reasoning = "No existing venues found for location, created new venue")
    city, region = parse_location(location)
    
    venue = Venue.create!(
      name: venue_name,
      city: city,
      administrative_area: region,
      country: extract_country_from_region(region),
      claude_matched: false,
      claude_confidence: 0,
      claude_reasoning: claude_reasoning
    )

    # Create initial venue name record
    venue.venue_names.create!(
      name: venue_name,
      start_date: show_date,
      current: true
    )

    venue
  end

  def extract_country_from_region(region)
    # Simple heuristic - if region is 2 characters, assume US state
    return 'US' if region&.length == 2
    
    # Could add more country detection logic here
    'US'
  end

  def log_claude_consultation(venue:, original_venue_name:, location:, show_date:, prompt:, response:, result:)
    # If no venue matched, we might need to create the consultation without a venue_id
    # But since the table requires venue_id, we'll only log when we have a matched venue
    return unless venue

    begin
      # Convert the full Anthropic response to JSON for storage
      response_json = {
        id: response.id,
        type: response.type,
        role: response.role,
        content: response.content.map(&:to_h),
        model: response.model,
        stop_reason: response.stop_reason,
        stop_sequence: response.stop_sequence,
        usage: response.usage.to_h
      }

      venue.claude_venue_consultations.create!(
        original_venue_name: original_venue_name,
        location: location,
        show_date: show_date,
        prompt_sent: prompt,
        response_json: response_json,
        model_version: "claude-3-haiku-20240307",
        confidence: result[:confidence],
        match_found: result[:match_found],
        reasoning: result[:reasoning]
      )
    rescue => e
      Rails.logger.error "Failed to log Claude consultation: #{e.message}"
    end
  end
end