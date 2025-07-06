#!/usr/bin/env ruby

failed_venues = Venue.where(research_status: "failed")
puts "Queuing #{failed_venues.count} failed venues for research..."

failed_venues.find_each do |venue|
  venue.update!(research_status: "pending")
  VenueResearchJob.perform_later(venue.id)
end

puts "All jobs queued! Current totals:"
puts "  Pending: #{Venue.where(research_status: 'pending').count}"  
puts "  Ready jobs: #{SolidQueue::ReadyExecution.count}"
puts "Monitor progress at http://localhost:3000/venues"