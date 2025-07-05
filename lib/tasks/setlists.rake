namespace :setlists do
  desc "Import all DMB setlist JSON files"
  task import: :environment do
    puts "Starting DMB setlist import..."
    
    start_time = Time.current
    importer = SetlistImportService.new
    
    # Progress callback to show import progress
    progress_callback = ->(current, total, filename) do
      percent = ((current.to_f / total) * 100).round(1)
      puts "[#{current}/#{total}] (#{percent}%) #{filename}"
    end
    
    importer.import_all(progress_callback: progress_callback)
    
    duration = (Time.current - start_time).round(2)
    puts "\nImport completed in #{duration} seconds"
    
    # Generate summary reports
    puts "\nGenerating reports..."
    
    # Venue matching report
    if importer.imported_count > 0
      venue_matcher = VenueMatchingService.new
      venue_matcher.generate_unmatched_report(Venue.all)
      
      # Song deduplication report  
      song_deduplicator = SongDeduplicationService.new
      song_deduplicator.generate_deduplication_report(Song.all)
    end
  end

  desc "Import a specific date range of setlist files"
  task :import_range, [:start_date, :end_date] => :environment do |_t, args|
    unless args.start_date && args.end_date
      puts "Usage: rake setlists:import_range[1999-01-01,1999-12-31]"
      exit 1
    end
    
    start_date = Date.parse(args.start_date)
    end_date = Date.parse(args.end_date)
    
    puts "Importing setlists from #{start_date} to #{end_date}..."
    
    importer = SetlistImportService.new
    json_files = Dir.glob(Rails.root.join("tools", "dmb_scraper", "setlists", "*.json"))
    
    # Filter files by date range
    date_filtered_files = json_files.select do |file|
      # Extract date from filename (YYYY_MM_DD format)
      filename = File.basename(file, ".json")
      if filename.match(/^(\d{4})_(\d{2})_(\d{2})/)
        file_date = Date.new($1.to_i, $2.to_i, $3.to_i)
        file_date >= start_date && file_date <= end_date
      else
        false
      end
    end
    
    puts "Found #{date_filtered_files.size} files in date range"
    
    date_filtered_files.each_with_index do |file_path, index|
      begin
        importer.import_file(file_path)
        puts "[#{index + 1}/#{date_filtered_files.size}] #{File.basename(file_path)}"
      rescue => e
        puts "Error importing #{File.basename(file_path)}: #{e.message}"
      end
    end
    
    puts "\nRange import completed"
    puts "Imported: #{importer.imported_count}"
    puts "Skipped: #{importer.skipped_count}" 
    puts "Errors: #{importer.error_count}"
  end

  desc "Import a single setlist file for testing"
  task :import_single, [:filename] => :environment do |_t, args|
    unless args.filename
      puts "Usage: rake setlists:import_single[2005_09_10_red_rocks_amphitheatre_morrison_co_0001.json]"
      exit 1
    end
    
    file_path = Rails.root.join("tools", "dmb_scraper", "setlists", args.filename)
    
    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit 1
    end
    
    puts "Importing single file: #{args.filename}"
    
    importer = SetlistImportService.new
    importer.import_file(file_path)
    
    if importer.imported_count > 0
      puts "✓ Successfully imported"
    elsif importer.skipped_count > 0
      puts "- Skipped (already exists)"
    else
      puts "✗ Import failed"
      importer.errors.each { |error| puts "  #{error[:error]}" }
    end
  end

  desc "Validate imported setlist data integrity"
  task validate: :environment do
    puts "Validating setlist data integrity..."
    
    total_shows = Show.count
    total_songs = Song.count
    total_setlist_songs = SetlistSong.count
    total_venues = Venue.count
    
    puts "\n" + "=" * 50
    puts "DATA SUMMARY"
    puts "=" * 50
    puts "Shows: #{total_shows}"
    puts "Songs: #{total_songs}"
    puts "Setlist entries: #{total_setlist_songs}"
    puts "Venues: #{total_venues}"
    
    # Validation checks
    puts "\n" + "=" * 50
    puts "VALIDATION CHECKS"
    puts "=" * 50
    
    # Check for shows without setlists
    shows_without_setlists = Show.left_joins(:setlist_songs).where(setlist_songs: { id: nil })
    puts "Shows without setlists: #{shows_without_setlists.count}"
    if shows_without_setlists.any?
      puts "  Examples:"
      shows_without_setlists.limit(5).each do |show|
        puts "    - #{show.display_name}"
      end
    end
    
    # Check for duplicate shows
    duplicate_shows = Show.group(:band_id, :venue_id, :show_date).having("COUNT(*) > 1")
    puts "Duplicate shows: #{duplicate_shows.count}"
    if duplicate_shows.any?
      puts "  Found #{duplicate_shows.count} sets of duplicates"
    end
    
    # Check setlist song position integrity
    broken_positions = Show.joins(:setlist_songs)
                          .group("shows.id, setlist_songs.set_type")
                          .having("COUNT(DISTINCT setlist_songs.position) != COUNT(setlist_songs.id)")
    puts "Shows with broken position sequences: #{broken_positions.count}"
    
    # Check for songs with unusual performance counts
    never_played = Song.left_joins(:setlist_songs).where(setlist_songs: { id: nil })
    puts "Songs never performed: #{never_played.count}"
    
    very_rare = Song.joins(:setlist_songs).group("songs.id").having("COUNT(setlist_songs.id) = 1")
    puts "Songs performed only once: #{very_rare.count}"
    
    very_frequent = Song.joins(:setlist_songs).group("songs.id").having("COUNT(setlist_songs.id) > 100")
    puts "Songs performed 100+ times: #{very_frequent.count}"
    
    # Check venue data quality
    venues_without_location = Venue.where("city IS NULL OR administrative_area IS NULL")
    puts "Venues missing location data: #{venues_without_location.count}"
    
    # Check for potential song duplicates
    song_deduplicator = SongDeduplicationService.new
    potential_duplicates = song_deduplicator.find_potential_duplicates
    puts "Potential song duplicates: #{potential_duplicates.size}"
    if potential_duplicates.any?
      puts "  Examples:"
      potential_duplicates.first(3).each do |dup|
        puts "    - '#{dup[:song].title}' similar to: #{dup[:similar].map { |s| s[:title] }.join(', ')}"
      end
    end
    
    puts "=" * 50
    puts "Validation completed"
  end

  desc "Generate statistics about the imported setlist data"
  task stats: :environment do
    puts "Generating setlist statistics..."
    
    # Date range
    earliest_show = Show.order(:show_date).first
    latest_show = Show.order(:show_date).last
    date_range = "#{earliest_show&.show_date} to #{latest_show&.show_date}"
    
    # Most played songs
    most_played = Song.joins(:setlist_songs)
                     .group("songs.id")
                     .order("COUNT(setlist_songs.id) DESC")
                     .limit(10)
                     .includes(:setlist_songs)
    
    # Most visited venues
    most_visited = Venue.joins(:shows)
                       .group("venues.id")
                       .order("COUNT(shows.id) DESC")
                       .limit(10)
                       .includes(:shows)
    
    # Shows by year
    shows_by_year = Show.group("EXTRACT(year FROM show_date)")
                       .order("EXTRACT(year FROM show_date)")
                       .count
    
    # Cover songs
    cover_songs = Song.where(is_cover_song: true).count
    
    # Average setlist length
    avg_setlist_length = SetlistSong.joins(:show)
                                   .group("shows.id")
                                   .count
                                   .values
                                   .sum.to_f / Show.count
    
    puts "\n" + "=" * 60
    puts "DMB SETLIST STATISTICS"
    puts "=" * 60
    puts "Date range: #{date_range}"
    puts "Total shows: #{Show.count}"
    puts "Total unique songs: #{Song.count}"
    puts "Cover songs: #{cover_songs}"
    puts "Average setlist length: #{avg_setlist_length.round(1)} songs"
    
    puts "\nMost played songs:"
    most_played.each_with_index do |song, index|
      puts "  #{index + 1}. #{song.title} (#{song.performance_count} times)"
    end
    
    puts "\nMost visited venues:"
    most_visited.each_with_index do |venue, index|
      show_count = venue.shows.count
      puts "  #{index + 1}. #{venue.name}, #{venue.city} (#{show_count} shows)"
    end
    
    puts "\nShows by year:"
    shows_by_year.each do |year, count|
      puts "  #{year}: #{count} shows"
    end
    
    puts "=" * 60
  end

  desc "Clean up and reset all imported setlist data"
  task clean: :environment do
    puts "WARNING: This will delete all imported setlist data!"
    print "Are you sure? (type 'yes' to confirm): "
    confirmation = STDIN.gets.chomp
    
    unless confirmation == "yes"
      puts "Aborted"
      exit 1
    end
    
    puts "Cleaning up setlist data..."
    
    ActiveRecord::Base.transaction do
      deleted_setlist_songs = SetlistSong.delete_all
      deleted_album_songs = AlbumSong.delete_all
      deleted_songs = Song.delete_all
      deleted_shows = Show.delete_all
      
      puts "Deleted:"
      puts "  - #{deleted_setlist_songs} setlist song entries"
      puts "  - #{deleted_album_songs} album song entries"
      puts "  - #{deleted_songs} songs"
      puts "  - #{deleted_shows} shows"
      puts "  (Venues and bands preserved)"
    end
    
    puts "Cleanup completed"
  end
end