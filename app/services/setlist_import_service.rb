class SetlistImportService
  attr_reader :imported_count, :skipped_count, :error_count, :errors

  def initialize(skip_geocoding: true)
    @imported_count = 0
    @skipped_count = 0
    @error_count = 0
    @errors = []
    @skip_geocoding = skip_geocoding
  end

  def import_all(progress_callback: nil)
    json_files = Dir.glob(Rails.root.join("tools", "dmb_scraper", "setlists", "*.json"))
    total_files = json_files.size

    puts "Found #{total_files} setlist files to import..."
    puts "Geocoding: #{@skip_geocoding ? 'DISABLED' : 'ENABLED'}"

    # Set geocoding flag for this thread
    Thread.current[:skip_geocoding] = @skip_geocoding

    json_files.each_with_index do |file_path, index|
      begin
        import_file(file_path)
        progress_callback&.call(index + 1, total_files, File.basename(file_path))
        
        # Clear caches every 50 files to prevent stale data issues
        if (index + 1) % 50 == 0
          clear_caches
          puts "  Cleared caches after #{index + 1} files"
        end
      rescue => e
        record_error(file_path, e)
      end
    end

    # Clear geocoding flag
    Thread.current[:skip_geocoding] = nil

    generate_import_summary
  end

  def import_file(file_path)
    data = JSON.parse(File.read(file_path))
    
    # Skip if show already exists
    if show_exists?(data)
      @skipped_count += 1
      return
    end

    # Process the show data
    show = create_show_from_data(data)
    
    if show.persisted?
      @imported_count += 1
      puts "✓ Imported: #{show.display_name}"
    else
      record_error(file_path, "Failed to save show: #{show.errors.full_messages.join(', ')}")
    end
  end

  private

  def show_exists?(data)
    show_date = Date.parse(data["date"])
    band = find_or_create_band(data["band"])
    
    # For existence check, try to find venue by name/location first
    venue = find_venue_by_name_and_location(data["venue"], data["location"])
    return false unless venue # If venue doesn't exist, show doesn't exist
    
    Show.exists?(band: band, venue: venue, show_date: show_date)
  end

  def create_show_from_data(data)
    Show.transaction do
      # Find or create band and venue
      band = find_or_create_band(data["band"])
      show_date = Date.parse(data["date"])
      
      # First check if there's a poster for this exact date
      poster = Poster.find_by(release_date: show_date)
      if poster&.venue
        venue = poster.venue
        puts "  ✅ Using poster venue: #{venue.name} (from poster for #{show_date})"
      else
        venue = find_or_create_basic_venue(data["venue"], data["location"])
      end
      
      # Create show
      show = Show.create!(
        band: band,
        venue: venue,
        show_date: show_date,
        show_notes: extract_show_notes(data),
        scraped_at: parse_scraped_at(data["scraped_at"])
      )

      # Import setlist songs
      import_setlist_songs(show, data["setlist"])
      
      # Queue Claude venue matching job if venue needs research
      if venue && !venue.claude_matched?
        ClaudeVenueMatchingJob.perform_later(venue.id)
      end
      
      show
    end
  rescue => e
    # Return unsaved show with errors for error reporting
    show = Show.new
    show.errors.add(:base, e.message)
    show
  end

  def find_or_create_band(band_name)
    Band.find_or_create_by(name: band_name)
  end

  def find_or_create_song(song_title)
    # Simple song creation without deduplication for now
    # Cleaned source data should minimize duplicates
    Song.find_or_create_by(title: song_title.strip)
  end

  def find_venue_by_name_and_location(venue_name, location)
    # Simple venue lookup for existence checks
    city, region = parse_location_for_lookup(location)
    return nil unless city
    
    Venue.where(
      "LOWER(name) = ? AND LOWER(city) = ? AND LOWER(administrative_area) = ?",
      venue_name.downcase.strip,
      city.downcase,
      region.downcase
    ).first
  end

  def find_or_create_basic_venue(venue_name, location)
    # NO exact matching - Claude decides everything
    
    # Parse location
    city, region = parse_location_for_lookup(location)
    return nil unless city
    
    # Check if there are other venues in this city
    existing_venues_in_city = Venue.where(
      "LOWER(city) = ? AND LOWER(administrative_area) = ?",
      city.downcase,
      region.downcase
    )
    
    if existing_venues_in_city.any?
      # Other venues exist - Claude will research if this setlist venue matches any existing venue
      claude_reasoning = "Pending Claude venue matching research - other venues exist in this location"
      claude_matched = false
      claude_confidence = nil
    else
      # First venue in this city - mark as unique
      claude_reasoning = "No existing venues found for location, confirmed as unique venue"
      claude_matched = false
      claude_confidence = 100
    end
    
    # Always create new venue - Claude will determine if it should be merged later
    venue = Venue.create!(
      name: venue_name.strip,
      city: city,
      administrative_area: region,
      country: extract_country_from_region(region),
      claude_matched: claude_matched,
      claude_confidence: claude_confidence,
      claude_reasoning: claude_reasoning
    )

    # Create initial venue name record
    venue.venue_names.create!(
      name: venue_name.strip,
      start_date: Date.current,
      current: true
    )

    venue
  end

  def parse_location_for_lookup(location_string)
    return [nil, nil] unless location_string

    parts = location_string.split(',').map(&:strip)
    case parts.length
    when 2
      [parts[0], parts[1]]
    when 1
      [parts[0], 'Unknown']
    else
      [parts[0], parts[1]]
    end
  end

  def extract_country_from_region(region)
    # Simple heuristic - if region is 2 characters, assume US state
    return 'US' if region&.length == 2
    
    # Could add more country detection logic here
    'US'
  end

  def import_setlist_songs(show, setlist_data)
    # Import main set
    setlist_data["main_set"]&.each do |song_data|
      create_setlist_song(show, song_data, "main_set")
    end

    # Import encore
    setlist_data["encore"]&.each do |song_data|
      create_setlist_song(show, song_data, "encore")
    end
  end

  def create_setlist_song(show, song_data, set_type)
    song = find_or_create_song(song_data["title"])
    
    # Build notes JSON from the song data
    notes = build_setlist_notes(song_data)

    SetlistSong.create!(
      show: show,
      song: song,
      set_type: set_type,
      position: song_data["position"],
      notes: notes.any? ? notes : nil
    )
  end

  def build_setlist_notes(song_data)
    notes = []

    # Add guest information
    if song_data["guests"].present? && song_data["guests"].any?
      song_data["guests"].each do |guest|
        notes << {
          "type" => "guest_musician",
          "name" => guest,
          "instrument" => "unknown" # Could be enhanced later
        }
      end
    end

    # Add other notes
    if song_data["notes"].present? && song_data["notes"].any?
      song_data["notes"].each do |note|
        case note.downcase.strip
        when "segue"
          notes << { "type" => "segue", "note" => "segue into next song" }
        when "guest performance"
          # This is often captured with an asterisk in the title
          notes << { "type" => "special_performance", "description" => "guest performance" }
        when /jam/i
          notes << { "type" => "jam", "description" => note }
        when /tease/i
          notes << { "type" => "tease", "description" => note }
        else
          notes << { "type" => "note", "description" => note }
        end
      end
    end

    notes
  end

  def extract_show_notes(data)
    notes_parts = []
    
    if data["show_notes"]&.dig("additional").present?
      notes_parts << data["show_notes"]["additional"].strip
    end
    
    legend = data["show_notes"]&.dig("legend")
    if legend.is_a?(Hash) && legend.any?
      legend_text = legend.map { |k, v| "#{k}: #{v}" }.join(", ")
      notes_parts << "Legend: #{legend_text}"
    end

    notes_parts.join("\n\n").presence
  end

  def parse_scraped_at(scraped_at_string)
    return nil unless scraped_at_string.present?
    
    Time.parse(scraped_at_string)
  rescue
    nil
  end

  def record_error(file_path, error)
    @error_count += 1
    error_message = error.is_a?(Exception) ? error.message : error.to_s
    @errors << { file: File.basename(file_path), error: error_message }
    puts "✗ Error importing #{File.basename(file_path)}: #{error_message}"
  end

  def clear_caches
    # Clear song deduplication cache
    @song_deduplicator = SongDeduplicationService.new
  end

  def generate_import_summary
    puts "\n" + "=" * 60
    puts "SETLIST IMPORT SUMMARY"
    puts "=" * 60
    puts "✓ Successfully imported: #{@imported_count} shows"
    puts "- Skipped (already exists): #{@skipped_count} shows"
    puts "✗ Errors: #{@error_count} files"
    puts "Total files processed: #{@imported_count + @skipped_count + @error_count}"
    
    if @errors.any?
      puts "\nERRORS:"
      @errors.each do |error|
        puts "  #{error[:file]}: #{error[:error]}"
      end
    end
    
    puts "=" * 60
  end
end