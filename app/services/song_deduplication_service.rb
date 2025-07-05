class SongDeduplicationService
  # Common song title variations and canonical titles
  SONG_ALIASES = {
    # Common abbreviations
    "#34" => "#34",
    "#41" => "#41",
    "ANTS" => "Ants Marching",
    "BOWA" => "Best of What's Around",
    "DDTW" => "Don't Drink the Water",
    "DIDO" => "Drive In Drive Out",
    "LIOG" => "Lie in Our Graves",
    "SMTS" => "So Much to Say",
    "TMM" => "Too Much",
    "WWYS" => "What Would You Say",
    
    # Common variations
    "Angel From Montgomery" => "Angel from Montgomery",
    "Best of Whats Around" => "Best of What's Around",
    "Cant Stop" => "Can't Stop",
    "Dont Drink the Water" => "Don't Drink the Water",
    "Dont Burn The Pig" => "Don't Burn the Pig",
    "Grace Is Gone" => "Grace is Gone",
    "Granny" => "Granny (Instrumental)",
    "I Did It" => "I Did It",
    "Lie In Our Graves" => "Lie in Our Graves",
    "Long Black Veil" => "Long Black Veil",
    "So Much To Say" => "So Much to Say",
    "The Stone" => "Stone",
    "Two Step" => "Two Step",
    "What Would You Say" => "What Would You Say"
  }.freeze

  # Common symbols and annotations to strip from titles
  TITLE_CLEANERS = [
    /\s*\*\s*$/, # Asterisk at end (guest performance marker)
    /\s*\+\s*$/, # Plus at end
    /\s*>\s*/, # Arrow (segue marker)
    /\s*->\s*/, # Arrow with dashes
    /\s*\[.*?\]\s*/, # Bracketed notes
    /\s*\(.*?\)\s*$/ # Parenthetical notes at end only
  ].freeze

  def initialize
    @song_cache = {}
  end

  def find_or_create_song(raw_title)
    # Use cache for repeated lookups
    return @song_cache[raw_title] if @song_cache[raw_title]

    # Clean and normalize the title
    cleaned_title = clean_song_title(raw_title)
    canonical_title = find_canonical_title(cleaned_title)

    # Find existing song or create new one
    song = find_existing_song(canonical_title) || create_new_song(canonical_title, raw_title)
    
    @song_cache[raw_title] = song
    song
  end

  def clean_song_title(title)
    cleaned = title.strip
    
    # Apply all cleaners
    TITLE_CLEANERS.each do |pattern|
      cleaned = cleaned.gsub(pattern, "").strip
    end
    
    # Normalize whitespace
    cleaned.gsub(/\s+/, " ").strip
  end

  def find_canonical_title(title)
    # Check direct aliases first
    return SONG_ALIASES[title] if SONG_ALIASES[title]
    
    # Check case-insensitive aliases
    SONG_ALIASES.each do |alias_name, canonical|
      return canonical if alias_name.downcase == title.downcase
    end
    
    # Check if title is already a canonical form
    canonical_match = SONG_ALIASES.values.find { |canonical| canonical.downcase == title.downcase }
    return canonical_match if canonical_match
    
    # Return original title if no alias found
    title
  end

  def find_existing_song(title)
    # Try exact match first
    song = Song.find_by("LOWER(title) = ?", title.downcase)
    return song if song

    # Try fuzzy matching for slight variations
    find_by_fuzzy_match(title)
  end

  def find_by_fuzzy_match(title)
    # Use PostgreSQL trigram similarity for fuzzy matching
    escaped_title = ActiveRecord::Base.connection.quote(title)
    candidates = Song.where("similarity(title, ?) > 0.8", title)
                    .order(Arel.sql("similarity(title, #{escaped_title}) DESC"))
                    .limit(3)

    best_match = candidates.first
    
    if best_match && candidates.size == 1
      # Only auto-match if there's a single, very close match
      puts "🎵 Fuzzy matched '#{title}' to existing song '#{best_match.title}'"
      return best_match
    elsif candidates.any?
      # Multiple matches - log for manual review
      puts "⚠️  Multiple song matches for '#{title}': #{candidates.map(&:title).join(', ')}"
      return candidates.first # Take best match but log the ambiguity
    end

    nil
  end

  def create_new_song(title, original_title = nil)
    # Determine if it's likely a cover song
    is_cover = detect_cover_song(title)
    
    song = Song.create!(
      title: title,
      is_cover_song: is_cover,
      original_artist: is_cover ? guess_original_artist(title) : nil
    )
    
    puts "🎵 Created new song: #{song.title}#{is_cover ? ' (cover)' : ''}"
    song
  rescue ActiveRecord::RecordInvalid => e
    puts "❌ Failed to create song '#{title}': #{e.message}"
    raise
  end

  def detect_cover_song(title)
    # Common patterns that indicate cover songs
    cover_indicators = [
      /^(The\s+)?Beatles/i,
      /^Bob\s+Dylan/i,
      /^Neil\s+Young/i,
      /^Joni\s+Mitchell/i,
      /^JJ\s+Cale/i,
      /Angel\s+from\s+Montgomery/i, # John Prine cover
      /Long\s+Black\s+Veil/i, # Traditional cover
      /All\s+Along\s+the\s+Watchtower/i, # Bob Dylan cover
      /Blackbird/i # Beatles cover
    ]
    
    cover_indicators.any? { |pattern| title.match?(pattern) }
  end

  def guess_original_artist(title)
    case title.downcase
    when /angel\s+from\s+montgomery/
      "John Prine"
    when /long\s+black\s+veil/
      "Traditional"
    when /all\s+along\s+the\s+watchtower/
      "Bob Dylan"
    when /blackbird/
      "The Beatles"
    when /crazy/
      "Patsy Cline"
    else
      nil
    end
  end

  # Generate a report of song deduplication results
  def generate_deduplication_report(processed_songs)
    puts "\n" + "=" * 50
    puts "SONG DEDUPLICATION REPORT"
    puts "=" * 50
    
    new_songs = processed_songs.select { |s| s.created_at > 1.hour.ago }
    cover_songs = new_songs.select(&:is_cover_song)
    
    puts "New songs created: #{new_songs.size}"
    puts "Cover songs identified: #{cover_songs.size}"
    
    if cover_songs.any?
      puts "\nCover songs:"
      cover_songs.each do |song|
        artist_info = song.original_artist ? " (#{song.original_artist})" : ""
        puts "  - #{song.title}#{artist_info}"
      end
    end
    
    # Show most frequently appearing new songs
    if new_songs.any?
      frequent_songs = new_songs.joins(:setlist_songs)
                                .group("songs.id")
                                .having("COUNT(setlist_songs.id) >= 3")
                                .includes(:setlist_songs)
      
      if frequent_songs.any?
        puts "\nFrequently played new songs (3+ performances):"
        frequent_songs.each do |song|
          puts "  - #{song.title} (#{song.performance_count} performances)"
        end
      end
    end
    
    puts "=" * 50
  end

  # Method to manually review and fix song duplicates
  def find_potential_duplicates
    duplicates = []
    
    Song.find_each do |song|
      escaped_title = ActiveRecord::Base.connection.quote(song.title)
      similar = Song.where.not(id: song.id)
                   .where("similarity(title, ?) > 0.8 AND similarity(title, ?) < 1.0", song.title, song.title)
                   .order(Arel.sql("similarity(title, #{escaped_title}) DESC"))
      
      if similar.any?
        duplicates << {
          song: song,
          similar: similar.map { |s| { title: s.title, id: s.id } }
        }
      end
    end
    
    duplicates
  end
end