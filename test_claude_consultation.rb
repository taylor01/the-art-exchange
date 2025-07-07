#!/usr/bin/env ruby

puts "🧪 Testing Claude consultation system with Charlotte Coliseum case..."

# Sample ambiguous case from our analysis
sample_case = {
  "setlist_venue_name" => "Charlotte Coliseum",
  "setlist_location" => "Charlotte, NC",
  "confidence" => 0,
  "setlist_files_affected" => ["1995_12_28_charlotte_coliseum_charlotte_nc_0001.json"],
  "show_dates" => ["1995-12-28"],
  "import_strategy" => "sequential_stage_4",
  "claude_consultation_required" => true,
  "invalid_date_venues" => [
    {
      "venue_id" => 182,
      "venue_name" => "Independence Arena",
      "historical_name" => "Charlotte Coliseum",
      "date_range" => "1955 - 1988"
    }
  ],
  "reason" => "Exact name match found but venue name was not active during setlist dates (1995-12-28)",
  "match_type" => "exact_name_invalid_dates"
}

puts "📋 Sample case details:"
puts "   Venue: #{sample_case['setlist_venue_name']}"
puts "   Location: #{sample_case['setlist_location']}"
puts "   Show date: #{sample_case['show_dates'].first}"
puts "   Issue: #{sample_case['reason']}"

puts "\n🤖 Queueing consultation job..."
job = ClaudeVenueConsultationJob.perform_later(sample_case)

puts "✅ Job queued with ID: #{job.job_id}"
puts "\n📊 Check job status with:"
puts "   bin/rails runner 'puts SolidQueue::Job.find(\"#{job.job_id}\").status rescue \"Job not found\"'"

puts "\n⏰ Job should complete in ~30-60 seconds depending on Claude's research time"
puts "💾 Results will be stored in venue_consultation_results.json"