class ClaudeVenueConsultationJob < ApplicationJob
  queue_as :default

  def perform(ambiguous_case_data)
    Rails.logger.info "🤖 Starting Claude venue consultation for: #{ambiguous_case_data['setlist_venue_name']} in #{ambiguous_case_data['setlist_location']}"
    
    consultation_result = case ambiguous_case_data['match_type']
    when 'exact_name_invalid_dates'
      handle_date_validation_consultation(ambiguous_case_data)
    when 'requires_claude_consultation'
      handle_fuzzy_match_consultation(ambiguous_case_data)
    else
      Rails.logger.error "Unknown consultation type: #{ambiguous_case_data['match_type']}"
      return
    end

    # Store the consultation result for processing
    store_consultation_result(ambiguous_case_data, consultation_result)
    
    Rails.logger.info "✅ Claude consultation completed for #{ambiguous_case_data['setlist_venue_name']}"
  end

  private

  def handle_date_validation_consultation(case_data)
    venue_name = case_data['setlist_venue_name']
    location = case_data['setlist_location']
    show_dates = case_data['show_dates']
    invalid_venues = case_data['invalid_date_venues']

    prompt = build_date_validation_prompt(venue_name, location, show_dates, invalid_venues)
    
    Rails.logger.info "🔍 Consulting Claude on date validation case: #{venue_name}"
    Rails.logger.info "📝 Prompt sent to Claude:\n#{prompt}"
    
    response = query_claude(prompt)
    
    Rails.logger.info "🤖 Claude's full response:\n#{response}"
    Rails.logger.info "=" * 80
    
    parse_date_validation_response(response, case_data)
  end

  def handle_fuzzy_match_consultation(case_data)
    venue_name = case_data['setlist_venue_name']
    location = case_data['setlist_location']
    show_dates = case_data['show_dates']
    potential_matches = case_data['potential_matches']

    prompt = build_fuzzy_consultation_prompt(venue_name, location, show_dates, potential_matches)
    
    Rails.logger.info "🔍 Consulting Claude on fuzzy match case: #{venue_name}"
    Rails.logger.info "📝 Prompt sent to Claude:\n#{prompt}"
    
    response = query_claude(prompt)
    
    Rails.logger.info "🤖 Claude's full response:\n#{response}"
    Rails.logger.info "=" * 80
    
    parse_fuzzy_consultation_response(response, case_data)
  end

  def build_date_validation_prompt(venue_name, location, show_dates, invalid_venues)
    venue_details = invalid_venues.map do |venue|
      "- #{venue['venue_name']} (historical name: '#{venue['historical_name']}' active #{venue['date_range']})"
    end.join("\n")

    <<~PROMPT
      VENUE MATCHING CONSULTATION - Date Validation Analysis

      TASK: Research Dave Matthews Band performances and determine venue matching strategy.

      SETLIST DETAILS:
      - Venue Name: "#{venue_name}"
      - Location: #{location}
      - Show Dates: #{show_dates.join(', ')}

      DATABASE CONFLICT:
      We found exact name matches in our venue database, but the venue name periods don't align with the show dates:

      #{venue_details}

      RESEARCH REQUEST:
      Please research Dave Matthews Band performances on these specific dates (#{show_dates.join(', ')}) in #{location}. 
      Look for:
      1. Where DMB actually performed on these dates
      2. Venue name used in concert reviews, setlist archives, or fan sites
      3. Any venue name changes or rebranding around these dates
      4. Whether this venue had multiple names during different periods

      Based on your research, please determine:
      - Is this the SAME venue with incomplete/inaccurate date ranges in our database?
      - Or should we CREATE a NEW venue entry for a different location with the same name?

      RESPONSE FORMAT:
      Decision: [SAME_VENUE or NEW_VENUE]
      Venue_ID: [if SAME_VENUE, provide the venue_id from the list above]
      Confidence: [1-10 scale]
      Research_Summary: [Brief summary of what you found about DMB shows on these dates]
      Reasoning: [Explanation of your decision]

      Please be thorough in your research and provide specific details about what you discovered regarding Dave Matthews Band's performances on these dates.
    PROMPT
  end

  def build_fuzzy_consultation_prompt(venue_name, location, show_dates, potential_matches)
    matches_details = potential_matches.map do |match|
      "- #{match['venue_name']} (ID: #{match['venue_id']}, Similarity: #{(match['similarity_score'] * 100).round(1)}%)"
    end.join("\n")

    <<~PROMPT
      VENUE MATCHING CONSULTATION - Fuzzy Match Analysis

      TASK: Research Dave Matthews Band performances and determine best venue match.

      SETLIST DETAILS:
      - Venue Name: "#{venue_name}"
      - Location: #{location}
      - Show Dates: #{show_dates.join(', ')}

      POTENTIAL VENUE MATCHES:
      We found these existing venues in #{location} but none had high similarity scores:

      #{matches_details}

      RESEARCH REQUEST:
      Please research Dave Matthews Band performances on these specific dates (#{show_dates.join(', ')}) in #{location}.
      Look for:
      1. Where DMB actually performed on these dates
      2. Venue name used in concert coverage, reviews, or setlist archives
      3. Alternative names or nicknames for venues in this city
      4. Whether "#{venue_name}" might be a former name, nickname, or informal reference

      Based on your research, please determine:
      - Does "#{venue_name}" match any of the existing venues above?
      - Or should we CREATE a NEW venue entry?

      RESPONSE FORMAT:
      Decision: [MATCH_EXISTING or NEW_VENUE]
      Venue_ID: [if MATCH_EXISTING, provide the venue_id from the list above]
      Confidence: [1-10 scale]
      Research_Summary: [Brief summary of what you found about DMB shows on these dates]
      Reasoning: [Explanation of your decision and any venue name connections discovered]

      Please provide specific details about what you discovered regarding Dave Matthews Band's performances on these dates and venue naming.
    PROMPT
  end

  def query_claude(prompt)
    require 'anthropic'
    
    client = Anthropic::Client.new(api_key: ENV['ANTHROPIC_API_KEY'])
    
    response = client.messages.create(
      model: "claude-3-5-sonnet-20241022",
      max_tokens: 2000,
      messages: [
        {
          role: "user",
          content: prompt
        }
      ]
    )

    response.content.first.text
  rescue => e
    Rails.logger.error "Claude API error: #{e.message}"
    "ERROR: Could not consult Claude - #{e.message}"
  end

  def parse_date_validation_response(response, case_data)
    decision = extract_decision(response)
    venue_id = extract_venue_id(response)
    confidence = extract_confidence(response)
    research_summary = extract_research_summary(response)
    reasoning = extract_reasoning(response)

    {
      consultation_type: 'date_validation',
      decision: decision,
      venue_id: venue_id,
      confidence: confidence,
      research_summary: research_summary,
      reasoning: reasoning,
      raw_response: response,
      case_data: case_data
    }
  end

  def parse_fuzzy_consultation_response(response, case_data)
    decision = extract_decision(response)
    venue_id = extract_venue_id(response)
    confidence = extract_confidence(response)
    research_summary = extract_research_summary(response)
    reasoning = extract_reasoning(response)

    {
      consultation_type: 'fuzzy_match',
      decision: decision,
      venue_id: venue_id,
      confidence: confidence,
      research_summary: research_summary,
      reasoning: reasoning,
      raw_response: response,
      case_data: case_data
    }
  end

  def extract_decision(response)
    if match = response.match(/Decision:\s*(SAME_VENUE|NEW_VENUE|MATCH_EXISTING)/i)
      match[1].upcase
    else
      'UNKNOWN'
    end
  end

  def extract_venue_id(response)
    if match = response.match(/Venue_ID:\s*(\d+)/i)
      match[1].to_i
    else
      nil
    end
  end

  def extract_confidence(response)
    if match = response.match(/Confidence:\s*(\d+)/i)
      match[1].to_i
    else
      0
    end
  end

  def extract_research_summary(response)
    if match = response.match(/Research_Summary:\s*(.*?)(?=\n\w+:|$)/mi)
      match[1].strip
    else
      'No research summary provided'
    end
  end

  def extract_reasoning(response)
    if match = response.match(/Reasoning:\s*(.*?)$/mi)
      match[1].strip
    else
      'No reasoning provided'
    end
  end

  def store_consultation_result(case_data, consultation_result)
    # Store in a consultation results table or JSON file for now
    results_file = Rails.root.join('venue_consultation_results.json')
    
    results = if File.exist?(results_file)
      JSON.parse(File.read(results_file))
    else
      { 'consultations' => [] }
    end

    consultation_entry = {
      'timestamp' => Time.current.iso8601,
      'venue_name' => case_data['setlist_venue_name'],
      'location' => case_data['setlist_location'],
      'show_dates' => case_data['show_dates'],
      'consultation_result' => consultation_result
    }

    results['consultations'] << consultation_entry
    File.write(results_file, JSON.pretty_generate(results))
    
    Rails.logger.info "💾 Stored consultation result for #{case_data['setlist_venue_name']}"
  end
end