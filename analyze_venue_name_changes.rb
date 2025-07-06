#!/usr/bin/env ruby

puts "🔍 Analyzing venue name changes from completed research..."

completed_venues = Venue.where(research_status: 'completed')
puts "📊 Analyzing #{completed_venues.count} completed venues"

venues_needing_review = []

completed_venues.each do |venue|
  current_venue_name = venue.venue_names.find_by(current: true)
  
  if current_venue_name && current_venue_name.name != venue.name
    venues_needing_review << {
      venue: venue,
      db_name: venue.name,
      suggested_name: current_venue_name.name
    }
    
    venue.update!(
      name_needs_review: true,
      suggested_current_name: current_venue_name.name
    )
    
    puts "🔄 #{venue.name} → #{current_venue_name.name}"
  end
end

puts
puts "✅ Analysis complete!"
puts "📋 Venues needing name review: #{venues_needing_review.count}"

if venues_needing_review.any?
  puts
  puts "📝 SUMMARY OF NAME CHANGES NEEDED:"
  venues_needing_review.each do |item|
    puts "   • #{item[:db_name]} → #{item[:suggested_name]}"
  end
  
  puts
  puts "🔍 To review flagged venues:"
  puts "   Venue.where(name_needs_review: true)"
end