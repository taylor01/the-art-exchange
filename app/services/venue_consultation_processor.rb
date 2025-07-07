class VenueConsultationProcessor
  attr_reader :processing_results

  def initialize
    @results_file = Rails.root.join('venue_analysis_data', 'venue_consultation_results.json')
    @processing_results = {
      processed: 0,
      same_venue_matches: 0,
      existing_venue_matches: 0,
      new_venues_created: 0,
      skipped_missing_venue_id: 0,
      errors: []
    }
  end

  def process_all_consultations
    puts "🤖 Processing Claude venue consultation results..."
    
    unless File.exist?(@results_file)
      puts "❌ No consultation results file found: #{@results_file}"
      return @processing_results
    end

    consultation_data = JSON.parse(File.read(@results_file))
    consultations = consultation_data['consultations']

    puts "📊 Found #{consultations.size} consultation results to process"

    consultations.each_with_index do |consultation, index|
      puts "📋 [#{index + 1}/#{consultations.size}] Processing: #{consultation['venue_name']}"
      
      begin
        process_consultation(consultation)
        @processing_results[:processed] += 1
      rescue => e
        error_msg = "Error processing #{consultation['venue_name']}: #{e.message}"
        puts "❌ #{error_msg}"
        @processing_results[:errors] << error_msg
      end
    end

    display_processing_summary
    @processing_results
  end

  def process_consultation(consultation)
    result = consultation['consultation_result']
    decision = result['decision']
    venue_name = consultation['venue_name']
    location = consultation['location']
    show_dates = consultation['show_dates']
    case_data = result['case_data']

    case decision
    when 'SAME_VENUE'
      handle_same_venue_decision(result, case_data)
    when 'MATCH_EXISTING'
      handle_existing_venue_match(result, case_data)
    when 'NEW_VENUE'
      handle_new_venue_creation(consultation, result, case_data)
    else
      raise "Unknown decision: #{decision}"
    end
  end

  private

  def handle_same_venue_decision(result, case_data)
    venue_id = result['venue_id']
    
    if venue_id.nil?
      puts "   ⚠️  SAME_VENUE decision but no venue_id provided - skipping"
      @processing_results[:skipped_missing_venue_id] += 1
      return
    end
    
    venue = Venue.find(venue_id)
    
    puts "   ✅ Matched to existing venue: #{venue.name} (ID: #{venue_id})"
    puts "   📝 Research: #{result['research_summary']}"
    puts "   🎯 Confidence: #{result['confidence']}/10"
    
    # Create venue mapping record for import processing
    create_venue_mapping_record(case_data, venue, result, 'same_venue_confirmed')
    
    @processing_results[:same_venue_matches] += 1
  end

  def handle_existing_venue_match(result, case_data)
    venue_id = result['venue_id']
    
    if venue_id.nil?
      puts "   ⚠️  MATCH_EXISTING decision but no venue_id provided - skipping"
      @processing_results[:skipped_missing_venue_id] += 1
      return
    end
    
    venue = Venue.find(venue_id)
    
    puts "   ✅ Matched to existing venue: #{venue.name} (ID: #{venue_id})"
    puts "   📝 Research: #{result['research_summary']}"
    puts "   🎯 Confidence: #{result['confidence']}/10"
    
    # Create venue mapping record for import processing
    create_venue_mapping_record(case_data, venue, result, 'existing_venue_matched')
    
    @processing_results[:existing_venue_matches] += 1
  end

  def handle_new_venue_creation(consultation, result, case_data)
    venue_name = consultation['venue_name']
    location = consultation['location']
    city, state = parse_location(location)
    
    puts "   🆕 Creating new venue: #{venue_name}"
    puts "   📝 Research: #{result['research_summary']}"
    puts "   🎯 Confidence: #{result['confidence']}/10"
    
    # Create new venue with Claude's research data
    venue = Venue.create!(
      name: venue_name,
      city: city,
      administrative_area: state,
      country: 'United States',
      research_summary: result['research_summary'],
      claude_reasoning: result['reasoning']
    )
    
    # VenueName records will be handled later during setlist import
    
    puts "   ✅ Created venue ID: #{venue.id}"
    
    # Create venue mapping record for import processing
    create_venue_mapping_record(case_data, venue, result, 'new_venue_created')
    
    @processing_results[:new_venues_created] += 1
  end

  def create_venue_mapping_record(case_data, venue, consultation_result, mapping_type)
    # Store the mapping decision for later import processing
    mapping_file = Rails.root.join('venue_analysis_data', 'claude_venue_mappings.json')
    
    mappings = if File.exist?(mapping_file)
      JSON.parse(File.read(mapping_file))
    else
      { 'mappings' => [] }
    end

    mapping_entry = {
      'setlist_venue_name' => case_data['setlist_venue_name'],
      'setlist_location' => case_data['setlist_location'],
      'matched_venue_id' => venue.id,
      'matched_venue_name' => venue.name,
      'confidence' => consultation_result['confidence'] * 10, # Convert to 100-point scale
      'mapping_type' => mapping_type,
      'setlist_files_affected' => case_data['setlist_files_affected'],
      'show_dates' => case_data['show_dates'],
      'claude_research_summary' => consultation_result['research_summary'],
      'claude_reasoning' => consultation_result['reasoning'],
      'consultation_timestamp' => Time.current.iso8601,
      'import_strategy' => 'claude_consultation_resolved'
    }

    mappings['mappings'] << mapping_entry
    File.write(mapping_file, JSON.pretty_generate(mappings))
  end

  def parse_location(location_string)
    return [nil, nil] unless location_string.present? && location_string.is_a?(String)

    parts = location_string.split(',').map(&:strip)
    case parts.length
    when 2
      [parts[0], parts[1]]
    when 1
      [parts[0], nil]
    else
      [parts[0], parts[1]]
    end
  end

  def display_processing_summary
    puts "\n" + "=" * 60
    puts "🤖 CLAUDE CONSULTATION PROCESSING COMPLETE"
    puts "=" * 60
    
    puts "📊 PROCESSING RESULTS:"
    puts "   ✅ Total processed: #{@processing_results[:processed]}"
    puts "   🔗 Same venue confirmed: #{@processing_results[:same_venue_matches]}"
    puts "   🎯 Existing venue matches: #{@processing_results[:existing_venue_matches]}"
    puts "   🆕 New venues created: #{@processing_results[:new_venues_created]}"
    puts "   ⚠️  Skipped (missing venue_id): #{@processing_results[:skipped_missing_venue_id]}"
    puts "   ❌ Errors: #{@processing_results[:errors].size}"
    
    if @processing_results[:errors].any?
      puts "\n❌ ERRORS:"
      @processing_results[:errors].each { |error| puts "   - #{error}" }
    end
    
    puts "\n💾 Claude venue mappings saved to: venue_analysis_data/claude_venue_mappings.json"
    puts "🚀 Ready for setlist import with Claude-resolved venue mappings!"
    puts "=" * 60
  end
end