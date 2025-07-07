#!/usr/bin/env ruby

puts "🐛 Debugging venue creation issue..."

# Load the first NEW_VENUE consultation result
results = JSON.parse(File.read('venue_analysis_data/venue_consultation_results.json'))
new_venue_consultation = results['consultations'].find do |c|
  c['consultation_result']['decision'] == 'NEW_VENUE'
end

if new_venue_consultation
  puts "📋 Found NEW_VENUE consultation: #{new_venue_consultation['venue_name']}"
  
  consultation = new_venue_consultation
  result = consultation['consultation_result']
  case_data = result['case_data']
  
  puts "✅ consultation structure OK"
  puts "   venue_name: #{consultation['venue_name']}"
  puts "   location: #{consultation['location']}"
  
  puts "✅ result structure OK"
  puts "   decision: #{result['decision']}"
  puts "   confidence: #{result['confidence']}"
  
  puts "✅ case_data structure OK"
  puts "   show_dates: #{case_data['show_dates'].inspect}"
  puts "   show_dates class: #{case_data['show_dates'].class}"
  
  # Test the mapping creation logic
  mapping_entry = {
    'setlist_venue_name' => case_data['setlist_venue_name'],
    'setlist_location' => case_data['setlist_location'],
    'matched_venue_id' => 999, # dummy ID
    'matched_venue_name' => consultation['venue_name'],
    'confidence' => result['confidence'] * 10,
    'mapping_type' => 'new_venue_created',
    'setlist_files_affected' => case_data['setlist_files_affected'],
    'show_dates' => case_data['show_dates'],
    'claude_research_summary' => result['research_summary'],
    'claude_reasoning' => result['reasoning'],
    'consultation_timestamp' => Time.current.iso8601,
    'import_strategy' => 'claude_consultation_resolved'
  }
  
  puts "✅ Mapping entry created successfully"
  puts "   Keys: #{mapping_entry.keys}"
  
else
  puts "❌ No NEW_VENUE consultations found"
end