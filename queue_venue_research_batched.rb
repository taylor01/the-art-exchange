#!/usr/bin/env ruby

puts "🔍 Starting batched venue research queuing..."

venues = Venue.all.order(:id)
batch_size = 10
delay_between_batches = 60.seconds

puts "📊 Total venues: #{venues.count}"
puts "📦 Batch size: #{batch_size}"
puts "⏱️  Delay between batches: #{delay_between_batches / 60} minutes"

total_batches = (venues.count / batch_size.to_f).ceil
total_time = (total_batches - 1) * (delay_between_batches / 60)

puts "🚀 Will create #{total_batches} batches over #{total_time.round(1)} minutes"
puts

venues.each_slice(batch_size).with_index do |batch, index|
  delay = index * delay_between_batches
  
  puts "📋 Batch #{index + 1}/#{total_batches}: Venues #{batch.first.id}-#{batch.last.id} (delay: #{delay/60}min)"
  
  batch.each do |venue|
    VenueResearchJob.set(wait: delay).perform_later(venue.id)
    print "."
  end
  
  puts " ✅ Queued #{batch.size} jobs"
end

puts
puts "🎉 All venue research jobs queued!"
puts "⏰ First batch starts immediately"
puts "⏰ Last batch starts in #{total_time.round(1)} minutes"
puts "🔍 Monitor with: bin/rails runner \"puts SolidQueue::Job.where(job_class: 'VenueResearchJob').count\""