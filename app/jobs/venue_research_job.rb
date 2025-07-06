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
          researched_at: Time.current,
          research_status: "completed"
        )

        # Update historical names if Claude found any
        if research_result[:historical_names].present?
          research_result[:historical_names].each do |name_info|
            venue.venue_names.find_or_create_by(name: name_info[:name]) do |vn|
              vn.start_date = name_info[:start_date]
              vn.end_date = name_info[:end_date]
              vn.current = name_info[:current] || false
            end
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
      model: "claude-3-haiku-20240307",
      max_tokens: 2000,
      messages: [
        {
          role: "user",
          content: prompt
        }
      ]
    )

    content = response.content[0].text
    Rails.logger.info "Claude research response for #{venue.name}: #{content[0..200]}..."

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
      Please research this venue extensively using your knowledge and provide a comprehensive report. I need:

      1. VENUE SUMMARY: A detailed description of the venue including:
         - Physical description and architecture
         - Notable features or characteristics
         - Historical significance or notable events
         - Current operating status

      2. HISTORICAL NAMES: All names this venue has operated under with specific date ranges:
         - Include sponsor naming rights changes
         - Include rebranding or ownership changes
         - Include any informal or colloquial names

      3. LOCATION HISTORY: Any address or location changes over time

      4. CAPACITY CHANGES: How venue capacity has changed over time

      5. CONFIDENCE ASSESSMENT: Rate your confidence in this information (0-100%)

      6. SOURCES: What types of sources this information typically comes from

      IMPORTANT: Be thorough but honest about uncertainty. If information is unclear or conflicting, mention that in your confidence assessment.

      Please respond with ONLY a JSON object in this exact format:
      {
        "summary": "Comprehensive venue description and history",
        "historical_names": [
          {
            "name": "Historical or alternative name",
            "start_date": "YYYY-MM-DD or null if unknown",
            "end_date": "YYYY-MM-DD or null if still current/unknown",
            "current": false,
            "notes": "Context about this name usage"
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
            "end_date": "YYYY-MM-DD or null",#{' '}
            "notes": "Context about capacity change"
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
      .gsub(/(\d),(\d)/, '\1\2')     # Fix number commas like "16,500" -> "16500"
      .gsub(/,(\s*[}\]])/, '\1')     # Remove trailing commas before } or ]
    
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
    
    Date.parse(date_string.to_s)
  rescue Date::Error, ArgumentError
    Rails.logger.warn "Failed to parse date: #{date_string}"
    nil
  end
end
