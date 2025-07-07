#!/usr/bin/env ruby

puts "🔍 Queueing venue research for pending venues..."

# Get all venues that need research
pending_venues = Venue.where(research_status: 'pending').order(:id)
batch_size = 20
batch_delay = 2.minutes  # 2 minutes between batches

puts "📊 Found #{pending_venues.count} pending venues"
puts "📦 Batch size: #{batch_size} venues"
puts "⏱️  Delay between batches: #{batch_delay / 60} minutes"

total_batches = (pending_venues.count / batch_size.to_f).ceil
total_time = (total_batches - 1) * (batch_delay / 60)

puts "🚀 Will create #{total_batches} batches over #{total_time.round(1)} minutes"
puts

job_count = 0

pending_venues.each_slice(batch_size).with_index do |batch, batch_index|
  batch_number = batch_index + 1
  batch_delay_seconds = batch_index * batch_delay
  
  puts "📋 Batch #{batch_number}/#{total_batches}: #{batch.size} venues"
  puts "   ⏰ Batch starts in: #{batch_delay_seconds / 60} minutes"
  
  batch.each_with_index do |venue, venue_index|
    # Stagger individual jobs within batch by 30 seconds
    job_delay = batch_delay_seconds + (venue_index * 30.seconds)
    execution_time = Time.current + job_delay
    
    puts "   #{batch_number}.#{venue_index + 1} #{venue.name} (#{venue.location_summary})"
    puts "      ⏰ Scheduled for: #{execution_time.strftime('%H:%M:%S')}"
    
    VenueResearchJob.set(wait_until: execution_time).perform_later(venue.id)
    job_count += 1
  end
  
  puts "   ✅ Queued #{batch.size} jobs for batch #{batch_number}"
  puts
end

puts "=" * 60
puts "🎉 VENUE RESEARCH QUEUING COMPLETE"
puts "=" * 60
puts "✅ Total jobs queued: #{job_count}"
puts "⏰ First job starts: immediately"
puts "⏰ Last job starts: in #{total_time.round(1)} minutes"
puts "🔍 Estimated completion: #{(Time.current + total_time.minutes + 10.minutes).strftime('%H:%M:%S')}"
puts "📊 Monitor progress with: Venue.where(research_status: 'completed').count"
puts "=" * 60