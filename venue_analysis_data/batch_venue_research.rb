#!/usr/bin/env ruby

# Batch process all failed venues in foreground with proper environment
puts "🔍 Starting batch venue research..."

failed_venues = Venue.where(research_status: "failed")
total_count = failed_venues.count
puts "Found #{total_count} venues to research"

batch_size = 10
batch_count = 0
success_count = 0
failure_count = 0

failed_venues.find_in_batches(batch_size: batch_size) do |batch|
  batch_count += 1
  puts "\n📦 Processing batch #{batch_count} (#{batch.size} venues)..."
  
  batch.each_with_index do |venue, index|
    print "  #{batch_count}.#{index + 1} #{venue.name}... "
    
    venue.update!(research_status: "pending")
    VenueResearchJob.perform_now(venue.id)
    venue.reload
    
    if venue.research_status == "completed"
      print "✅ #{venue.research_confidence}%\n"
      success_count += 1
    else
      print "❌ Failed\n"
      failure_count += 1
    end
  end
  
  processed = (batch_count * batch_size).clamp(0, total_count)
  puts "  Batch complete. Progress: #{processed}/#{total_count} (#{success_count} ✅, #{failure_count} ❌)"
end

puts "\n🎉 Batch research complete!"
puts "Final results:"
puts "  ✅ Completed: #{Venue.where(research_status: 'completed').count}"
puts "  ❌ Failed: #{Venue.where(research_status: 'failed').count}"
puts "  📊 Total venues with research data: #{Venue.where(research_status: 'completed').sum { |v| v.venue_names.count }}"