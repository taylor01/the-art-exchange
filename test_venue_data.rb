#!/usr/bin/env ruby

puts "Checking venue research data availability..."
puts "Venues with research: #{Venue.where(research_status: 'completed').count}"
puts "Total venue names: #{VenueName.count}"
puts "Sample venue names:"
VenueName.joins(:venue).limit(5).each do |vn|
  puts "  - #{vn.name} (#{vn.venue.name} in #{vn.venue.city}, #{vn.venue.administrative_area})"
end