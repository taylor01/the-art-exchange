#!/usr/bin/env ruby

puts "Testing single background job with proper SolidQueue setup..."

venue = Venue.where(research_status: "failed").first
puts "Selected venue: #{venue.name}"

venue.update!(research_status: "pending")
VenueResearchJob.perform_later(venue.id)

puts "Job queued for #{venue.name}. Check status in a few seconds..."
puts "Current SolidQueue job count: #{SolidQueue::Job.count}"
puts "Ready executions: #{SolidQueue::ReadyExecution.count}"