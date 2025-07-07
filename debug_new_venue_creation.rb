#!/usr/bin/env ruby

puts "🐛 Debugging NEW_VENUE creation..."

# Load one NEW_VENUE consultation
results = JSON.parse(File.read('venue_analysis_data/venue_consultation_results.json'))
new_venue_consultation = results['consultations'].find do |c|
  c['consultation_result']['decision'] == 'NEW_VENUE'
end

consultation = new_venue_consultation
result = consultation['consultation_result']
case_data = result['case_data']

puts "📋 Testing with: #{consultation['venue_name']}"

# Test each step individually
begin
  puts "✅ Step 1: Basic data extraction"
  venue_name = consultation['venue_name']
  location = consultation['location']
  puts "   venue_name: #{venue_name.inspect}"
  puts "   location: #{location.inspect}"
  
  puts "✅ Step 2: Location parsing"
  # Inline the parse_location logic to test it
  if location.present? && location.is_a?(String)
    parts = location.split(',').map(&:strip)
    city = parts[0]
    state = parts.length >= 2 ? parts[1] : nil
    puts "   city: #{city.inspect}"
    puts "   state: #{state.inspect}"
  else
    puts "   ❌ Location issue: #{location.inspect} (class: #{location.class})"
    city = nil
    state = nil
  end
  
  puts "✅ Step 3: Venue creation parameters"
  venue_params = {
    name: venue_name,
    city: city,
    administrative_area: state,
    country: 'United States',
    research_summary: result['research_summary'],
    claude_reasoning: result['reasoning']
  }
  puts "   Venue params: #{venue_params.keys}"
  
  puts "✅ Step 4: Test venue creation (without actually creating)"
  # Don't actually create, just test the parameters
  puts "   Would create venue with: #{venue_params}"
  
  puts "✅ Step 5: Test mapping creation parameters"
  mapping_entry = {
    'setlist_venue_name' => case_data['setlist_venue_name'],
    'setlist_location' => case_data['setlist_location'],
    'matched_venue_id' => 999, # dummy
    'matched_venue_name' => venue_name,
    'confidence' => result['confidence'] * 10,
    'mapping_type' => 'new_venue_created',
    'setlist_files_affected' => case_data['setlist_files_affected'],
    'show_dates' => case_data['show_dates'],
    'claude_research_summary' => result['research_summary'],
    'claude_reasoning' => result['reasoning'],
    'consultation_timestamp' => Time.current.iso8601,
    'import_strategy' => 'claude_consultation_resolved'
  }
  puts "   Mapping entry keys: #{mapping_entry.keys}"
  
  puts "✅ All steps completed successfully!"
  
rescue => e
  puts "❌ Error at step: #{e.message}"
  puts "   Backtrace: #{e.backtrace.first(3)}"
end