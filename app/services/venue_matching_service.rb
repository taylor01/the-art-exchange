class VenueMatchingService
  # Common venue name variations and abbreviations
  VENUE_ALIASES = {
    "Red Rocks" => "Red Rocks Amphitheatre",
    "MSG" => "Madison Square Garden",
    "The Garden" => "Madison Square Garden",
    "The Gorge" => "Gorge Amphitheatre",
    "Riverbend" => "Riverbend Music Center",
    "Alpine Valley" => "Alpine Valley Music Theatre",
    "Darien Lake" => "Darien Lake Performing Arts Center",
    "Blossom" => "Blossom Music Center",
    "SPAC" => "Saratoga Performing Arts Center",
    "Hampton Coliseum" => "Hampton Coliseum",
    "Virginia Beach" => "Farm Bureau Live at Virginia Beach"
  }.freeze

  def initialize
    @match_cache = {}
  end

  def find_or_create_venue(venue_name, location_string)
    # Use cache for repeated lookups
    cache_key = "#{venue_name}|#{location_string}"
    return @match_cache[cache_key] if @match_cache[cache_key]

    venue = find_existing_venue(venue_name, location_string) || 
            create_new_venue(venue_name, location_string)
    
    @match_cache[cache_key] = venue
    venue
  end

  private

  def find_existing_venue(venue_name, location_string)
    # Parse location
    city, state = parse_location(location_string)
    
    # Try exact name match first
    venue = find_by_exact_match(venue_name, city, state)
    return venue if venue

    # Try normalized name match
    venue = find_by_normalized_match(venue_name, city, state)
    return venue if venue

    # Try alias matching
    venue = find_by_alias_match(venue_name, city, state)
    return venue if venue

    # Try fuzzy matching with similar names (disabled for now due to Rails SQL safety)
    # find_by_fuzzy_match(venue_name, city, state)
    nil
  end

  def find_by_exact_match(venue_name, city, state)
    query = Venue.where("name ILIKE ?", venue_name)
    query = query.where("city ILIKE ?", city) if city.present?
    query = query.where("administrative_area ILIKE ?", state) if state.present?
    query.first
  end

  def find_by_normalized_match(venue_name, city, state)
    normalized_name = normalize_venue_name(venue_name)
    
    query = Venue.where("LOWER(REPLACE(REPLACE(name, ' ', ''), '-', '')) = ?", normalized_name)
    query = query.where("city ILIKE ?", city) if city.present?
    query = query.where("administrative_area ILIKE ?", state) if state.present?
    query.first
  end

  def find_by_alias_match(venue_name, city, state)
    canonical_name = VENUE_ALIASES[venue_name] || VENUE_ALIASES.key(venue_name)
    return nil unless canonical_name

    find_by_exact_match(canonical_name, city, state)
  end

  def find_by_fuzzy_match(venue_name, city, state)
    # Use PostgreSQL trigram similarity for fuzzy matching
    base_query = Venue.where("similarity(name, ?) > 0.6", venue_name)
                     .order(Arel.sql("similarity(name, ?) DESC"), venue_name)
    
    # Add location constraints if available
    base_query = base_query.where("city ILIKE ?", city) if city.present?
    base_query = base_query.where("administrative_area ILIKE ?", state) if state.present?
    
    candidate = base_query.first
    
    # Log potential matches for review
    if candidate
      puts "🔗 Fuzzy matched '#{venue_name}' to existing venue '#{candidate.name}' (#{candidate.city}, #{candidate.administrative_area})"
    end
    
    candidate
  end

  def create_new_venue(venue_name, location_string)
    city, state = parse_location(location_string)
    
    # Determine venue type from name patterns
    venue_type = guess_venue_type(venue_name)
    
    venue = Venue.create!(
      name: venue_name,
      city: city,
      administrative_area: state,
      venue_type: venue_type,
      status: "active"
    )
    
    puts "🏟️  Created new venue: #{venue.name} (#{venue.city}, #{venue.administrative_area})"
    venue
  rescue ActiveRecord::RecordInvalid => e
    puts "❌ Failed to create venue '#{venue_name}': #{e.message}"
    raise
  end

  def parse_location(location_string)
    return [nil, nil] unless location_string.present?

    # Handle common formats:
    # "Morrison, CO"
    # "New York, NY" 
    # "George, WA"
    # "Los Angeles, CA"
    parts = location_string.split(",").map(&:strip)
    
    case parts.size
    when 2
      [parts[0], parts[1]]
    when 1
      # Just city or state provided
      [parts[0], nil]
    else
      [nil, nil]
    end
  end

  def normalize_venue_name(name)
    name.downcase
        .gsub(/[^a-z0-9]/, "") # Remove all non-alphanumeric
        .strip
  end

  def guess_venue_type(venue_name)
    name_lower = venue_name.downcase
    
    case name_lower
    when /amphitheat|pavilion|shed|lawn/
      "amphitheatre"
    when /arena|coliseum|center|dome/
      "arena"
    when /stadium/
      "stadium"
    when /theatre|theater|hall|auditorium/
      "theater"
    when /club|tavern|bar/
      "club"
    when /park|field|grounds/
      "outdoor"
    when /festival/
      "festival"
    else
      "venue" # Default fallback
    end
  end

  # Method to report unmatched venues for manual review
  def generate_unmatched_report(imported_venues)
    puts "\n" + "=" * 50
    puts "VENUE MATCHING REPORT"
    puts "=" * 50
    
    new_venues = imported_venues.select { |v| v.created_at > 1.hour.ago }
    
    if new_venues.any?
      puts "New venues created (#{new_venues.size}):"
      new_venues.each do |venue|
        puts "  - #{venue.name} (#{venue.city}, #{venue.administrative_area}) [#{venue.venue_type}]"
      end
    else
      puts "No new venues created - all matched to existing venues"
    end
    
    puts "=" * 50
  end
end