#!/usr/bin/env ruby

puts "🔄 Bulk accepting venue name changes..."

venues_to_update = Venue.where(name_needs_review: true)
puts "📊 Found #{venues_to_update.count} venues flagged for name review"

updated_count = 0

venues_to_update.find_each do |venue|
  old_name = venue.name
  new_name = venue.suggested_current_name
  
  venue.update!(
    name: new_name,
    name_needs_review: false,
    suggested_current_name: nil
  )
  
  puts "✅ #{old_name} → #{new_name}"
  updated_count += 1
end

puts
puts "🎉 Bulk update complete!"
puts "📋 Updated #{updated_count} venue names"
puts "🧹 Cleared all review flags"
puts
puts "Verification:"
puts "  Venues needing review: #{Venue.where(name_needs_review: true).count}"
puts "  Venues with suggestions: #{Venue.where.not(suggested_current_name: nil).count}"