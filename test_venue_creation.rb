#!/usr/bin/env ruby

puts "🧪 Testing actual venue creation..."

begin
  venue = Venue.create!(
    name: 'Test Venue Debug',
    city: 'Test City', 
    administrative_area: 'TX',
    country: 'United States',
    research_summary: 'Test summary',
    claude_reasoning: 'Test reasoning'
  )
  puts "✅ Created test venue ID: #{venue.id}"
  venue.destroy
  puts "✅ Cleaned up test venue"
rescue => e
  puts "❌ Venue creation failed: #{e.message}"
  puts "   Backtrace: #{e.backtrace.first(3)}"
end