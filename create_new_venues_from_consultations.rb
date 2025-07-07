#!/usr/bin/env ruby

puts "🆕 Creating new venues from Claude consultations..."

# Skip geocoding to avoid API errors
Thread.current[:skip_geocoding] = true

results = JSON.parse(File.read('venue_analysis_data/venue_consultation_results.json'))
mapping_file = Rails.root.join('venue_analysis_data', 'claude_venue_mappings.json')

# Load existing mappings
mappings = if File.exist?(mapping_file)
  JSON.parse(File.read(mapping_file))
else
  { 'mappings' => [] }
end

new_venue_consultations = results['consultations'].select do |c|
  c['consultation_result']['decision'] == 'NEW_VENUE'
end

puts "📊 Found #{new_venue_consultations.size} NEW_VENUE consultations to process"

created_count = 0
error_count = 0

new_venue_consultations.each_with_index do |consultation, index|
  result = consultation['consultation_result']
  case_data = result['case_data']
  
  venue_name = consultation['venue_name']
  location = consultation['location']
  
  puts "📋 [#{index + 1}/#{new_venue_consultations.size}] Creating: #{venue_name}"
  
  begin
    # Parse location
    if location.present? && location.is_a?(String)
      parts = location.split(',').map(&:strip)
      city = parts[0]
      state = parts.length >= 2 ? parts[1] : nil
    else
      city = nil
      state = nil
    end
    
    # Create venue
    venue = Venue.create!(
      name: venue_name,
      city: city,
      administrative_area: state,
      country: 'United States',
      research_summary: result['research_summary'],
      claude_reasoning: result['reasoning']
    )
    
    puts "   ✅ Created venue ID: #{venue.id}"
    
    # Add to mappings
    mapping_entry = {
      'setlist_venue_name' => case_data['setlist_venue_name'],
      'setlist_location' => case_data['setlist_location'],
      'matched_venue_id' => venue.id,
      'matched_venue_name' => venue.name,
      'confidence' => result['confidence'] * 10,
      'mapping_type' => 'new_venue_created',
      'setlist_files_affected' => case_data['setlist_files_affected'],
      'show_dates' => case_data['show_dates'],
      'claude_research_summary' => result['research_summary'],
      'claude_reasoning' => result['reasoning'],
      'consultation_timestamp' => Time.current.iso8601,
      'import_strategy' => 'claude_consultation_resolved'
    }
    
    mappings['mappings'] << mapping_entry
    created_count += 1
    
  rescue => e
    puts "   ❌ Error creating #{venue_name}: #{e.message}"
    error_count += 1
  end
end

# Save updated mappings
File.write(mapping_file, JSON.pretty_generate(mappings))

puts "\n" + "=" * 60
puts "🆕 NEW VENUE CREATION COMPLETE"
puts "=" * 60
puts "✅ Venues created: #{created_count}"
puts "❌ Errors: #{error_count}"
puts "📋 Total mappings: #{mappings['mappings'].size}"
puts "💾 Updated mappings file: venue_analysis_data/claude_venue_mappings.json"
puts "=" * 60