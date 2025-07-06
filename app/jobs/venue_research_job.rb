class VenueResearchJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 10.seconds, attempts: 3

  def perform(venue_id)
    venue = Venue.find(venue_id)

    # Skip if already researched
    return if venue.research_status == "completed"

    Rails.logger.info "🔍 Starting comprehensive research for: #{venue.name} (#{venue.city}, #{venue.administrative_area})"

    venue.update!(research_status: "in_progress")

    begin
      research_result = research_venue_with_claude(venue)

      if research_result[:success]
        venue.update!(
          research_summary: research_result[:summary],
          research_confidence: research_result[:confidence],
          research_sources: research_result[:sources],
          historical_significance: research_result[:historical_significance],
          unique_features: research_result[:unique_features],
          researched_at: Time.current,
          research_status: "completed"
        )

        # Update historical names if Claude found any
        if research_result[:historical_names].present?
          research_result[:historical_names].each do |name_info|
            venue_name = venue.venue_names.find_or_create_by(name: name_info[:name])
            venue_name.update!(
              start_date: name_info[:start_date],
              end_date: name_info[:end_date],
              current: name_info[:current] || false
            )
          end
        end

        Rails.logger.info "✅ Research completed for #{venue.name} (#{research_result[:confidence]}% confidence)"
      else
        venue.update!(
          research_status: "failed",
          research_summary: "Research failed: #{research_result[:error]}"
        )
        Rails.logger.error "❌ Research failed for #{venue.name}: #{research_result[:error]}"
      end

    rescue => e
      venue.update!(
        research_status: "failed",
        research_summary: "Research error: #{e.message}"
      )
      Rails.logger.error "❌ Research error for venue #{venue_id}: #{e.message}"
      raise e
    end
  end

  private

  def research_venue_with_claude(venue)
    api_key = ENV["ANTHROPIC_API_KEY"]
    unless api_key.present?
      Rails.logger.error "ANTHROPIC_API_KEY not found in environment"
      return {
        success: false,
        error: "ANTHROPIC_API_KEY not configured"
      }
    end

    client = Anthropic::Client.new(api_key: api_key)
    prompt = build_venue_research_prompt(venue)

    response = client.messages.create(
      model: "claude-3-5-sonnet-20241022",
      max_tokens: 3000,
      messages: [
        {
          role: "user",
          content: prompt
        }
      ]
    )

    content = response.content[0].text
    Rails.logger.info "Claude research response for #{venue.name}: #{content[0..200]}..."
    Rails.logger.info "FULL CLAUDE RESPONSE JSON: #{content}"

    parse_research_response(content)

  rescue => e
    Rails.logger.error "Claude API error for venue research: #{e.message}"
    {
      success: false,
      error: e.message
    }
  end

  def build_venue_research_prompt(venue)
    location_info = [ venue.city, venue.administrative_area, venue.country ].compact.join(", ")
    address_info = venue.address.present? ? "Address: #{venue.address}" : "Address: Unknown"

    <<~PROMPT
      I need comprehensive research on this concert venue for my database. Please investigate thoroughly and provide detailed information.

      VENUE TO RESEARCH:
      Name: #{venue.name}
      Location: #{location_info}
      #{address_info}
      Venue Type: #{venue.venue_type.presence || 'Unknown'}
      Capacity: #{venue.capacity.present? ? venue.capacity : 'Unknown'}

      RESEARCH TASK:
      Please research this venue extensively using your knowledge, particularly leveraging information from reputable sources such as:
      - Regional visitor authorities and tourism boards
      - Wikipedia and other encyclopedia sources
      - Official venue websites and documentation
      - Local historical societies and archives
      - Municipal records and city websites
      
      Provide a comprehensive report with the following information:

      1. VENUE SUMMARY: Write a comprehensive, site-ready narrative summary (2-3 paragraphs) that weaves together:
         - Physical description and architectural significance
         - Historical importance and notable events
         - What makes this venue unique for concert experiences
         - Key moments in music history at this location
         - Current status and cultural relevance
         This should be polished prose suitable for displaying on a website, not just bullet points.

      2. HISTORICAL NAMES: **CRITICAL** - Find ALL names this venue has EVER operated under with date ranges:
         - Include ALL sponsor naming rights changes (even short-term ones)
         - Include ALL rebranding or ownership changes
         - Include any informal, colloquial, or nickname variations
         - Search thoroughly for brief interim names or temporary naming
         - **IMPORTANT**: Use approximate date ranges when exact dates are unknown (e.g., "1980s", "early 1990s", "mid-2000s")
         - Ensure date ranges do NOT overlap - each name should have a distinct time period
         - If uncertain about timing, use broader approximate ranges and note the uncertainty

      3. LOCATION HISTORY: Any address or location changes over time

      4. CAPACITY CHANGES: How venue capacity has changed over time

      5. HISTORICAL SIGNIFICANCE: Notable events, concerts, or cultural moments at this venue:
         - Famous performances or recordings
         - Historical events or milestones
         - Architectural or design significance
         - Role in music history or local culture

      6. UNIQUE VENUE FEATURES: What makes this venue special for concert experiences:
         - Distinctive architecture or design elements
         - Acoustic characteristics or sound quality
         - Unique stage configurations or layouts
         - Notable amenities or fan experience features
         - Geographic or environmental setting advantages

      7. CONFIDENCE ASSESSMENT: Rate your confidence in this information (0-100%)

      8. SOURCES: What types of sources this information typically comes from

      IMPORTANT: 
      - Cross-reference information across multiple reputable sources when possible
      - Be thorough but honest about uncertainty - if information is unclear or conflicting, mention that in your confidence assessment
      - Prioritize official sources like visitor authorities, Wikipedia, and municipal records over less reliable sources

      Please respond with ONLY a JSON object in this exact format:
      {
        "summary": "Comprehensive venue description and history",
        "historical_names": [
          {
            "name": "Historical or alternative name",
            "start_date": "YYYY-MM-DD, YYYY, decade (e.g. '1980s'), or null if unknown",
            "end_date": "YYYY-MM-DD, YYYY, decade (e.g. '1990s'), or null if still current/unknown",
            "current": false,
            "notes": "Context about this name usage and any date uncertainty"
          }
        ],
        "location_changes": [
          {
            "address": "Historical address",
            "start_date": "YYYY-MM-DD or null",
            "end_date": "YYYY-MM-DD or null",
            "notes": "Context about location change"
          }
        ],
        "capacity_history": [
          {
            "capacity": 5000,
            "start_date": "YYYY-MM-DD or null",
            "end_date": "YYYY-MM-DD or null",
            "notes": "Context about capacity change"
          }
        ],
        "historical_significance": [
          {
            "event": "Notable event or performance",
            "date": "YYYY-MM-DD or approximate date",
            "description": "Detailed description of significance",
            "category": "performance|recording|historical_event|architectural|cultural"
          }
        ],
        "unique_features": [
          {
            "feature": "Feature name or characteristic",
            "description": "Detailed description of the feature",
            "category": "architecture|acoustics|stage|amenities|location"
          }
        ],
        "confidence": 85,
        "sources": ["Wikipedia", "Venue website", "Concert databases", "News articles"],
        "research_notes": "Any important caveats or uncertainties"
      }
    PROMPT
  end

  def parse_research_response(content)
    # Extract JSON from response
    json_match = content.match(/\{.*\}/m)
    return { success: false, error: "No JSON found in response" } unless json_match

    # Clean up JSON by removing control characters and fixing common issues
    clean_json = json_match[0]
      .gsub(/[\x00-\x1F\x7F]/, ' ')  # Remove control characters
      .gsub(/(\d),(\d)/, "\\1\\2")     # Fix number commas like "16,500" -> "16500"
      .gsub(/,(\s*[}\]])/, "\\1")     # Remove trailing commas before } or ]
    data = JSON.parse(clean_json)

    # Convert historical names to expected format with safe date parsing
    historical_names = data["historical_names"]&.map do |name_info|
      {
        name: name_info["name"],
        start_date: safe_parse_date(name_info["start_date"]),
        end_date: safe_parse_date(name_info["end_date"]),
        current: name_info["current"] || false,
        notes: name_info["notes"]
      }
    end || []

    {
      success: true,
      summary: data["summary"],
      confidence: data["confidence"].to_i,
      sources: data["sources"] || [],
      historical_names: historical_names,
      location_changes: data["location_changes"] || [],
      capacity_history: data["capacity_history"] || [],
      historical_significance: data["historical_significance"] || [],
      unique_features: data["unique_features"] || [],
      research_notes: data["research_notes"]
    }

  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse Claude research response: #{e.message}"
    Rails.logger.error "Response content: #{content}"
    {
      success: false,
      error: "Failed to parse JSON response: #{e.message}"
    }
  end

  def safe_parse_date(date_string)
    return nil unless date_string.present?
    return nil if date_string.to_s.downcase.include?("null")

    # Handle year-only strings by converting to January 1st of that year
    if date_string.to_s.match?(/^\d{4}$/)
      return Date.new(date_string.to_i, 1, 1)
    end

    # Handle decades by converting to start of decade
    if date_string.to_s.match?(/^(\d{4})s$/)
      decade_start = $1.to_i
      return Date.new(decade_start, 1, 1)
    end

    Date.parse(date_string.to_s)
  rescue Date::Error, ArgumentError
    Rails.logger.warn "Failed to parse date: #{date_string}"
    nil
  end
end
