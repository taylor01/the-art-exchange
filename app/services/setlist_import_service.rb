class SetlistImportService
  attr_reader :imported_count, :skipped_count, :error_count, :errors

  def initialize
    @imported_count = 0
    @skipped_count = 0
    @error_count = 0
    @errors = []
    @venue_matcher = VenueMatchingService.new
    @song_deduplicator = SongDeduplicationService.new
  end

  def import_all(progress_callback: nil)
    json_files = Dir.glob(Rails.root.join("tools", "dmb_scraper", "setlists", "*.json"))
    total_files = json_files.size

    puts "Found #{total_files} setlist files to import..."

    json_files.each_with_index do |file_path, index|
      begin
        import_file(file_path)
        progress_callback&.call(index + 1, total_files, File.basename(file_path))
      rescue => e
        record_error(file_path, e)
      end
    end

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
    venue = @venue_matcher.find_or_create_venue(data["venue"], data["location"])
    
    Show.exists?(band: band, venue: venue, show_date: show_date)
  end

  def create_show_from_data(data)
    Show.transaction do
      # Find or create band and venue
      band = find_or_create_band(data["band"])
      venue = @venue_matcher.find_or_create_venue(data["venue"], data["location"])
      
      # Create show
      show = Show.create!(
        band: band,
        venue: venue,
        show_date: Date.parse(data["date"]),
        show_notes: extract_show_notes(data),
        scraped_at: parse_scraped_at(data["scraped_at"])
      )

      # Import setlist songs
      import_setlist_songs(show, data["setlist"])
      
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
    song = @song_deduplicator.find_or_create_song(song_data["title"])
    
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
    
    if data["show_notes"]&.dig("legend").present? && data["show_notes"]["legend"].any?
      legend_text = data["show_notes"]["legend"].map { |k, v| "#{k}: #{v}" }.join(", ")
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