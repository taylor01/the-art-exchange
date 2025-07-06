#!/usr/bin/env ruby

# Test script for venue research
venue = Venue.where(research_status: "failed").first
puts "Testing improved parsing on: #{venue.name}"
puts "Original error: #{venue.research_summary}"

venue.update!(research_status: "pending")
VenueResearchJob.perform_now(venue.id)

venue.reload
puts "New status: #{venue.research_status}"

if venue.research_status == "completed"
  puts "✅ Success! Confidence: #{venue.research_confidence}%"
  puts "Historical names found: #{venue.venue_names.count}"
else
  puts "❌ Failed: #{venue.research_summary}"
end