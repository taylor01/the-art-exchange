#!/usr/bin/env ruby

failed_venues = Venue.where(research_status: "failed")
puts "Requeuing #{failed_venues.count} failed venues..."

failed_venues.find_each do |venue|
  puts "  Requeuing: #{venue.name}"
  venue.update!(research_status: "pending")
  VenueResearchJob.perform_later(venue.id)
end

puts "\n✅ All failed venues requeued!"
puts "Current status:"
puts "  Pending: #{Venue.where(research_status: 'pending').count}"
puts "  Ready jobs: #{SolidQueue::ReadyExecution.count}"
puts "\nMonitor progress at http://localhost:3000/venues"