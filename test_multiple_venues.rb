#!/usr/bin/env ruby

# Test multiple venues with different error types
failed_venues = Venue.where(research_status: "failed").limit(5)

failed_venues.each_with_index do |venue, index|
  puts "\n#{index + 1}. Testing: #{venue.name}"
  puts "   Original error: #{venue.research_summary.truncate(100)}"
  
  venue.update!(research_status: "pending")
  VenueResearchJob.perform_now(venue.id)
  venue.reload
  
  if venue.research_status == "completed"
    puts "   ✅ Success! #{venue.research_confidence}% confidence, #{venue.venue_names.count} names"
  else
    puts "   ❌ Still failed: #{venue.research_summary.truncate(100)}"
  end
end

puts "\n📊 Current totals:"
puts "Completed: #{Venue.where(research_status: 'completed').count}"
puts "Failed: #{Venue.where(research_status: 'failed').count}"