#!/usr/bin/env ruby

puts "🤖 Queueing Claude venue consultations for ambiguous cases..."

# Read the venue mapping analysis
analysis_file = Rails.root.join('venue_mapping_analysis.json')
unless File.exist?(analysis_file)
  puts "❌ Analysis file not found: #{analysis_file}"
  exit 1
end

analysis_data = JSON.parse(File.read(analysis_file))
ambiguous_cases = analysis_data['venue_mappings']['ambiguous_cases']

puts "📊 Found #{ambiguous_cases.size} ambiguous cases to process"

# Queue all consultation jobs with staggered scheduling
consultation_count = 0
skipped_count = 0
batch_size = 10
batch_delay = 120 # seconds between batches (2 minutes)

valid_cases = ambiguous_cases.select do |case_data|
  ['exact_name_invalid_dates', 'requires_claude_consultation'].include?(case_data['match_type'])
end

puts "📊 Will queue #{valid_cases.size} consultation jobs with staggered execution times"
puts "⏰ Batches of #{batch_size} every #{batch_delay} seconds to respect Claude API rate limits"

valid_cases.each_with_index do |case_data, index|
  venue_name = case_data['setlist_venue_name']
  location = case_data['setlist_location']
  match_type = case_data['match_type']
  
  # Calculate when this job should run (staggered by batch)
  batch_number = index / batch_size
  execution_delay = batch_number * batch_delay
  execution_time = Time.current + execution_delay.seconds
  
  puts "📋 [#{index + 1}/#{valid_cases.size}] Queueing: #{venue_name} (#{location})"
  puts "   ⏰ Scheduled for: #{execution_time.strftime('%H:%M:%S')} (#{execution_delay}s from now)"
  
  # Queue the consultation job with scheduled execution time
  ClaudeVenueConsultationJob.set(wait_until: execution_time).perform_later(case_data)
  consultation_count += 1
end

# Count skipped cases
ambiguous_cases.each do |case_data|
  unless ['exact_name_invalid_dates', 'requires_claude_consultation'].include?(case_data['match_type'])
    skipped_count += 1
  end
end

puts
puts "✅ Consultation queueing complete!"
puts "📋 Queued consultations: #{consultation_count}"
puts "⏭️  Skipped cases: #{skipped_count}"
puts
puts "🔍 Claude will now research each case using Dave Matthews Band performance data"
puts "💾 Results will be stored in venue_consultation_results.json"
puts
puts "Monitor job progress with:"
puts "   bin/rails runner 'puts SolidQueue::Job.where(job_class: \"ClaudeVenueConsultationJob\").group(:status).count'"