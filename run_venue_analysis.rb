#!/usr/bin/env ruby

puts "🚀 Starting SetlistVenueAnalyzer..."
analyzer = SetlistVenueAnalyzer.new
results = analyzer.analyze_all_setlists

puts "\n🎉 Analysis complete!"
puts "Results saved to: venue_mapping_analysis.json"