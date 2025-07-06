class ClaudeVenueMatchingJob < ApplicationJob
  queue_as :default
  
  retry_on StandardError, wait: 5.seconds, attempts: 3
  
  def perform(venue_id)
    venue = Venue.find(venue_id)
    
    # TEMPORARILY DISABLED: Legacy venue matching system removed
    # This job will be updated to use the new intelligent venue matching system
    Rails.logger.info "🚧 Claude venue matching job temporarily disabled for venue: #{venue.name} (ID: #{venue.id})"
    Rails.logger.info "   Job will be updated to use new intelligent venue matching system"
    return
    
    # Skip if already processed by Claude
    return if venue.claude_matched?
    
    Rails.logger.info "🤖 Starting Claude venue matching for: #{venue.name} (ID: #{venue.id})"
    
    # Find a representative show for this venue to get location and date context
    representative_show = venue.shows.order(:show_date).first
    return unless representative_show
    
    # Get all existing venues in the same location
    existing_venues = find_existing_venues_for_location(venue.city, venue.administrative_area)
    comparison_venues = existing_venues.where.not(id: venue.id) # Exclude self
    
    if comparison_venues.any?
      puts "🔍 Found #{existing_venues.count} existing venues in #{venue.city}, #{venue.administrative_area}"
      existing_venues.each { |v| puts "   - #{v.name}" }
      puts "🎯 Comparing against #{comparison_venues.count} other venues"
      comparison_venues.each { |v| puts "   - #{v.name}" }
      
      # REMOVED: ClaudeVenueMatchingService usage
      # Will be replaced with new intelligent venue matching
      match_result = { match_found: false, confidence: 0, reasoning: "Legacy service removed" }
      
      if match_result[:match_found] && match_result[:matched_venue]
        Rails.logger.info "✅ Claude found match: #{match_result[:matched_venue].name} (#{match_result[:confidence]}% confidence)"
        
        # Merge this venue into the matched venue
        merge_venues(venue, match_result[:matched_venue], match_result)
      else
        Rails.logger.info "❌ Claude found no match, marking venue as researched"
        
        # Mark as researched but no match found
        venue.update!(
          claude_matched: false,
          claude_confidence: match_result[:confidence],
          claude_reasoning: match_result[:reasoning]
        )
      end
    else
      Rails.logger.info "📍 No existing venues found, marking as unique"
      
      # No existing venues to match against
      venue.update!(
        claude_matched: false,
        claude_confidence: 100,
        claude_reasoning: "No existing venues found for location, confirmed as unique venue"
      )
    end
    
    Rails.logger.info "🏁 Completed Claude venue matching for: #{venue.name}"
  rescue => e
    Rails.logger.error "❌ Claude venue matching failed for venue #{venue_id}: #{e.message}"
    raise e
  end
  
  private
  
  def find_existing_venues_for_location(city, region)
    return Venue.none unless city && region
    
    Venue.where(
      "LOWER(city) = ? AND LOWER(administrative_area) = ?",
      city.downcase,
      region.downcase
    ).includes(:venue_names)
  end
  
  def merge_venues(source_venue, target_venue, match_result)
    Rails.logger.info "🔀 Merging #{source_venue.name} into #{target_venue.name}"
    
    ActiveRecord::Base.transaction do
      # Update target venue with Claude research results
      target_venue.update!(
        claude_matched: true,
        claude_confidence: match_result[:confidence],
        claude_reasoning: match_result[:reasoning]
      )
      
      # Add source venue name as historical name if different
      if source_venue.name != target_venue.name
        target_venue.add_historical_name(source_venue.name, source_venue.shows.minimum(:show_date) || Date.current)
      end
      
      # Add any additional historical names discovered by Claude
      if match_result[:historical_names].present?
        match_result[:historical_names].each do |historical_name|
          next if historical_name == target_venue.name || historical_name == source_venue.name
          
          # Only add if we don't already have this name
          unless target_venue.venue_names.where(name: historical_name).exists?
            target_venue.add_historical_name(historical_name, source_venue.shows.minimum(:show_date) || Date.current - 1.year)
          end
        end
      end
      
      # Update current name if Claude suggests it
      if match_result[:current_name].present? && match_result[:current_name] != target_venue.name
        target_venue.set_current_name(match_result[:current_name])
      end
      
      # Move all shows from source venue to target venue
      source_venue.shows.update_all(venue_id: target_venue.id)
      
      # Move all posters from source venue to target venue
      source_venue.posters.update_all(venue_id: target_venue.id)
      
      # Copy any additional venue data that might be useful
      if source_venue.address.present? && target_venue.address.blank?
        target_venue.update!(address: source_venue.address)
      end
      
      if source_venue.website.present? && target_venue.website.blank?
        target_venue.update!(website: source_venue.website)
      end
      
      # Delete the source venue (it's now merged)
      source_venue.destroy!
      
      Rails.logger.info "✅ Successfully merged venues"
    end
  end
end