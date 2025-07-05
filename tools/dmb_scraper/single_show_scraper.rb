#!/usr/bin/env ruby
# frozen_string_literal: true

# Single Show DMB Setlist Scraper for Testing
# Target: 12-14-2018 show for data quality fixes

require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'
require 'date'
require 'fileutils'
require 'set'

class SingleShowScraper
  BASE_URL = 'https://davematthewsband.com/setlists/'

  def initialize
    @options = { verbose: true }
    script_dir = File.dirname(File.expand_path(__FILE__))
    @output_dir = File.join(script_dir, 'setlists')
  end

  def ensure_output_directory
    FileUtils.mkdir_p(@output_dir)
    puts "Output directory: #{@output_dir}/"
  end

  def fetch_page(url, retries = 3)
    uri = URI(url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.open_timeout = 15
    http.read_timeout = 45

    begin
      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'

      response = http.request(request)

      if response.code.to_i == 200
        response.body
      else
        puts "Error fetching #{url}: HTTP #{response.code}"
        nil
      end
    rescue Net::TimeoutError, Net::OpenTimeout, Net::ReadTimeout => e
      if retries > 0
        puts "Timeout fetching #{url}, retrying in 3 seconds... (#{retries} retries left)"
        sleep(3)
        fetch_page(url, retries - 1)
      else
        puts "Failed to fetch #{url} after multiple retries: #{e.message}"
        nil
      end
    rescue StandardError => e
      puts "Error fetching #{url}: #{e.message}"
      nil
    ensure
      http.finish if http.started?
    end
  end

  def parse_setlist_page(html_content, year = nil)
    doc = Nokogiri::HTML(html_content)
    concerts = []

    puts "  Parsing setlists for year #{year}..."

    # Look for setlist content
    setlist_sections = find_setlist_sections(doc)
    puts "  Found #{setlist_sections.length} potential setlist sections"

    setlist_sections.each_with_index do |section, i|
      puts "  Processing setlist #{i + 1}"
      concert = parse_single_setlist(section)
      
      if concert && concert[:date]
        if year.nil? || concert[:date].start_with?(year.to_s)
          concerts << concert
          puts "    ✓ Found show: #{concert[:date]} at #{concert[:venue]}"
        else
          puts "    Skipping #{concert[:date]} (wrong year)"
        end
      end
    end

    concerts
  end

  def find_setlist_sections(doc)
    # Look for setlist-content class first
    setlist_content = doc.css('.setlist-content')
    if setlist_content.any?
      puts "Found #{setlist_content.length} setlist-content sections"
      return setlist_content
    end

    # Fallback selectors
    selectors = [
      '.tour-date-item',
      '.setlist-container', 
      '.concert-entry',
      'article',
      '.show-entry'
    ]

    selectors.each do |selector|
      elements = doc.css(selector)
      if elements.any?
        puts "Using selector: #{selector} (#{elements.length} elements)"
        return elements
      end
    end

    puts "No standard selectors found, using fallback"
    []
  end

  def parse_single_setlist(section)
    concert = {
      band: 'Dave Matthews Band',
      date: nil,
      venue: nil,
      location: nil,
      setlist: {
        main_set: [],
        encore: []
      },
      show_notes: {
        legend: {}
      },
      scraped_at: Time.now.iso8601
    }

    # Extract date from .date element
    date_element = section.css('.date').first
    if date_element
      date_text = date_element.text.strip
      puts "  Raw date text: '#{date_text}'"
      date_match = date_text.match(/(\d{2})\.(\d{2})\.(\d{4})/)
      if date_match
        month, day, year = date_match[1], date_match[2], date_match[3]
        concert[:date] = "#{year}-#{month.rjust(2, '0')}-#{day.rjust(2, '0')}"
        puts "  Parsed date: #{concert[:date]}"
      end
    end

    # Extract location from .loc element
    loc_element = section.css('.loc').first
    if loc_element
      location_text = loc_element.text.strip
      puts "  Raw location: '#{location_text}'"
      concert[:location] = clean_location(location_text)
      puts "  Cleaned location: '#{concert[:location]}'"
    end

    # Extract venue from .title h4 element
    title_element = section.css('.title h4').first
    if title_element
      venue_text = title_element.text.strip
      puts "  Raw venue: '#{venue_text}'"
      concert[:venue] = clean_venue_name(venue_text)
      puts "  Cleaned venue: '#{concert[:venue]}'"
    end

    # Parse setlist songs (this will also extract show notes for legend parsing)
    parse_songs_from_list(section, concert)

    # Validate essential data
    return nil unless concert[:date] && concert[:venue]

    concert
  rescue StandardError => e
    puts "Error parsing setlist: #{e.message}"
    puts e.backtrace.first(5)
    nil
  end

  def clean_venue_name(name)
    return name unless name
    
    # Remove HTML tags
    cleaned = name.gsub(/<[^>]*>/, ' ')
    
    # Normalize whitespace
    cleaned = cleaned.gsub(/\s+/, ' ').strip
    
    puts "    Venue cleaning: '#{name}' → '#{cleaned}'"
    cleaned
  end

  def clean_location(location)
    return location unless location
    
    # Remove HTML tags and normalize
    cleaned = location.gsub(/<[^>]*>/, ' ')
                     .gsub(/\s+/, ' ')
                     .strip
                     .gsub(/,\s*$/, '') # Remove trailing comma
    
    puts "    Location cleaning: '#{location}' → '#{cleaned}'"
    cleaned
  end

  def parse_songs_from_list(section, concert)
    puts "  Parsing songs..."
    
    # Extract show notes first to get legend for song parsing
    extract_show_notes(section, concert)
    legend = concert[:show_notes][:legend]
    puts "  Available legend: #{legend}" if legend.any?
    
    # Track which standard symbols we encounter to add to legend
    standard_symbols_found = Set.new
    
    # Parse main set - get only the first <ol> items, not those in .encore-text
    setlist_text = section.css('.setlist-text').first
    if setlist_text
      # Get li elements from the main setlist ol (not from .encore-text ol)
      main_set_items = setlist_text.css('> ol > li')
      
      puts "    Found #{main_set_items.length} main set items"
      position = 1

      main_set_items.each_with_index do |item, i|
        song_text = item.text.strip
        puts "    Main #{i+1}: '#{song_text}'"
        
        next if should_skip_song_line(song_text)

        song_info = parse_song_line(song_text, legend)
        if song_info[:title].empty?
          puts "      ⚠️  EMPTY TITLE DETECTED for: '#{song_text}'"
        end
        
        # Track standard symbols found
        song_info[:legend_items].each do |symbol|
          if is_standard_symbol?(symbol)
            standard_symbols_found.add(symbol)
          end
        end
        
        song_info[:position] = position
        concert[:setlist][:main_set] << song_info
        position += 1
      end
    end

    # Parse encore
    encore_text = section.css('.encore-text').first
    if encore_text
      encore_items = encore_text.css('li')
      puts "    Found #{encore_items.length} encore items"
      encore_position = 1

      encore_items.each_with_index do |item, i|
        song_text = item.text.strip
        puts "    Encore #{i+1}: '#{song_text}'"
        
        next if should_skip_song_line(song_text)

        song_info = parse_song_line(song_text, legend)
        if song_info[:title].empty?
          puts "      ⚠️  EMPTY TITLE DETECTED for: '#{song_text}'"
        end
        
        # Track standard symbols found
        song_info[:legend_items].each do |symbol|
          if is_standard_symbol?(symbol)
            standard_symbols_found.add(symbol)
          end
        end
        
        song_info[:position] = encore_position
        concert[:setlist][:encore] << song_info
        encore_position += 1
      end
    end
    
    # Add standard symbols to legend if they were found
    add_standard_symbols_to_legend(concert, standard_symbols_found)
  end

  def should_skip_song_line(song_text)
    return true if song_text.empty?
    return true if song_text.length < 3
    return true if song_text.downcase.start_with?('show notes')
    return true if song_text.match?(/^[*+→\s]+$/) # Just symbols
    false
  end

  def parse_song_line(line, legend = {})
    puts "      Parsing song line: '#{line}'"
    
    # Clean non-breaking spaces and other whitespace artifacts
    clean_line = line.gsub(/\u00A0/, ' ').strip
    
    song = {
      title: clean_line,
      guests: [],
      notes: [],
      legend_items: []
    }

    original_line = clean_line.dup
    
    # Look for legend symbols at end of line and record them
    if clean_line.match(/([*+→~]+)\s*$/)
      symbols = $1
      symbols.each_char do |symbol|
        song[:legend_items] << symbol
        puts "        Found legend symbol: #{symbol}"
      end
    end

    # Look for inline guest indicators (*text*)
    guest_matches = clean_line.scan(/\*([^*]+)\*/)
    guest_matches.each do |match|
      song[:guests] << match[0].strip
      puts "        Found inline guest: #{match[0].strip}"
    end

    # Look for segue indicators in middle of line (→)
    if clean_line.include?('→') && !clean_line.match(/→\s*$/)
      song[:notes] << "segue"
      puts "        Found inline segue indicator"
    end

    # Look for partial song indicators (parentheses)
    paren_content = []
    if clean_line.match?(/\([^)]+\)/)
      paren_matches = clean_line.scan(/\(([^)]+)\)/)
      paren_matches.each do |match|
        paren_content << match[0]
        song[:notes] << "partial: #{match[0]}"
        puts "        Found partial: #{match[0]}"
      end
    end

    # Clean the title by removing all special indicators
    clean_title = clean_line.gsub(/\*[^*]*\*/, '')        # Remove *inline guests*
                            .gsub(/→/, '')                  # Remove segue arrows
                            .gsub(/\([^)]*\)/, '')          # Remove (partial)
                            .gsub(/[*+→~]+\s*$/, '')        # Remove trailing symbols
                            .strip

    clean_title = clean_title.gsub(/^\d+[\.\s]*/, '').strip # Remove numbering

    # FIX: If title is empty but we found partial content, use the partial as title
    if clean_title.empty? && paren_content.any?
      clean_title = paren_content.first
      puts "        🔧 FIXED: Using partial content as title: '#{clean_title}'"
    end

    song[:title] = clean_title
    puts "        Final clean title: '#{song[:title]}'"
    puts "        Guests: #{song[:guests]}" if song[:guests].any?
    puts "        Notes: #{song[:notes]}" if song[:notes].any?
    puts "        Legend items: #{song[:legend_items]}" if song[:legend_items].any?

    song
  end

  def extract_show_notes(section, concert)
    notes_elements = section.css('.show-notes, .notes, .legend')

    if notes_elements.any?
      notes_text = notes_elements.text.gsub(/\u00A0/, ' ').strip
      puts "  Raw show notes: '#{notes_text}'"
      
      # Parse legend with improved patterns
      parse_legend(notes_text, concert)
      
      # Only add to additional if there's content that wasn't parsed as legend
      remaining_text = remove_legend_items(notes_text)
      if remaining_text && !remaining_text.strip.empty?
        concert[:show_notes][:additional] = remaining_text.strip
        puts "  Remaining notes: '#{remaining_text.strip}'"
      end
    end
  end

  def parse_legend(notes_text, concert)
    puts "    Parsing legend from: '#{notes_text}'"
    
    # Handle multiple formats:
    # Format 1: "* = Neil Young"  
    # Format 2: "* Neil Young+ Carter, Dave"
    # Format 3: "* Preservation Hall Jazz Band\n+ Carter, Dave, Stefan and Tim"
    
    # Try format with = or :
    legend_matches = notes_text.scan(/([*+→~]+)\s*[=:]\s*([^,\n]+)/)
    legend_matches.each do |symbol, meaning|
      clean_symbol = symbol.strip
      clean_meaning = meaning.gsub(/\u00A0/, ' ').strip
      concert[:show_notes][:legend][clean_symbol] = clean_meaning
      puts "    Found legend (format 1): #{clean_symbol} = #{clean_meaning}"
    end
    
    # Try format without separators - split on symbol boundaries
    if legend_matches.empty?
      # Look for patterns like "* Text+ Other Text" or "* Text\n+ Other Text"
      segments = notes_text.split(/(?=[*+→~])/).reject(&:empty?)
      segments.each do |segment|
        segment = segment.strip
        next if segment.empty?
        
        if segment.match(/^([*+→~]+)\s*(.+)/)
          symbol = $1.strip
          meaning = $2.strip
          
          # Clean up the meaning - remove trailing symbols that belong to next segment
          meaning = meaning.gsub(/[*+→~]+\s*$/, '').gsub(/\u00A0/, ' ').strip
          
          if !meaning.empty?
            concert[:show_notes][:legend][symbol] = meaning
            puts "    Found legend (format 2): #{symbol} = #{meaning}"
          end
        end
      end
    end
  end

  def remove_legend_items(notes_text)
    # Remove legend items from the text to get remaining notes
    cleaned = notes_text.dup
    
    # Remove format 1 patterns (with = or :)
    cleaned = cleaned.gsub(/[*+→~]+\s*[=:]\s*[^,\n]+/, '')
    
    # Remove format 2 patterns (symbol + text)
    cleaned = cleaned.gsub(/[*+→~]+\s*[^*+→~\n]+/, '')
    
    # Clean up extra whitespace and common note patterns
    cleaned = cleaned.gsub(/\n+/, '\n')
                    .gsub(/\s+/, ' ')
                    .gsub(/\(\s*song name\s*\)\s*indicates\s*a\s*partial\s*song/i, '')
                    .strip
    
    cleaned.empty? ? nil : cleaned
  end

  def is_standard_symbol?(symbol)
    # Only → (segue) is truly universal - other symbols are show-specific
    symbol == '→'
  end

  def add_standard_symbols_to_legend(concert, symbols_found)
    standard_meanings = {
      '→' => 'segue'
    }
    
    symbols_found.each do |symbol|
      if standard_meanings[symbol]
        concert[:show_notes][:legend][symbol] = standard_meanings[symbol]
        puts "  Added standard symbol to legend: #{symbol} = #{standard_meanings[symbol]}"
      end
    end
  end

  def sanitize_filename_part(text)
    return 'unknown' unless text && !text.empty?

    clean = text.downcase
                .gsub(/[^a-z0-9\s]/, ' ')
                .gsub(/\s+/, '_')
                .gsub(/_+/, '_')
                .gsub(/^_|_$/, '')

    clean = clean[0..30] if clean.length > 30
    clean.empty? ? 'unknown' : clean
  end

  def parse_location(location_str)
    return { city: 'unknown', region: 'unknown' } unless location_str

    parts = location_str.split(',').map(&:strip)

    if parts.length >= 2
      city = parts[0]
      region = parts[1]
      { city: sanitize_filename_part(city), region: sanitize_filename_part(region) }
    else
      { city: sanitize_filename_part(parts[0]), region: 'unknown' }
    end
  end

  def generate_filename(concert)
    return nil unless concert[:date] && concert[:venue]

    date_parts = concert[:date].split('-')
    year, month, day = date_parts[0], date_parts[1], date_parts[2]

    venue = sanitize_filename_part(concert[:venue])
    location = parse_location(concert[:location])

    base_name = "#{year}_#{month}_#{day}_#{venue}_#{location[:city]}_#{location[:region]}"

    counter = 1
    loop do
      suffix = counter.to_s.rjust(4, '0')
      filename = "#{base_name}_#{suffix}.json"
      filepath = File.join(@output_dir, filename)

      break filename unless File.exist?(filepath)
      counter += 1
    end
  end

  def save_concert_file(concert)
    filename = generate_filename(concert)
    return false unless filename

    filepath = File.join(@output_dir, filename)

    begin
      File.write(filepath, JSON.pretty_generate(concert))
      puts "✓ Saved: #{filename}"

      # Print detailed summary
      main_count = concert[:setlist][:main_set].length
      encore_count = concert[:setlist][:encore].length
      total_count = main_count + encore_count

      puts "\n📊 SHOW SUMMARY:"
      puts "  Date: #{concert[:date]}"
      puts "  Venue: #{concert[:venue]}"
      puts "  Location: #{concert[:location]}"
      puts "  Main set: #{main_count} songs"
      puts "  Encore: #{encore_count} songs" 
      puts "  Total: #{total_count} songs"
      
      # Check for data quality issues
      puts "\n🔍 DATA QUALITY CHECK:"
      empty_titles = (concert[:setlist][:main_set] + concert[:setlist][:encore]).select { |s| s[:title].empty? }
      if empty_titles.any?
        puts "  ❌ #{empty_titles.count} songs with empty titles!"
      else
        puts "  ✅ No empty titles found"
      end

      true
    rescue StandardError => e
      puts "Error saving #{filename}: #{e.message}"
      false
    end
  end

  def scrape_all_shows
    puts "🎯 Starting comprehensive DMB setlist scraping (2025 back to 1985)"
    ensure_output_directory

    start_year = 2025
    current_year = start_year
    all_concerts = []
    
    # Continue until we find a year with no setlists
    while current_year >= 1985 # Safety limit
      puts "\n📅 Fetching shows from #{current_year}..."
      url = "#{BASE_URL}?year=#{current_year}"
      puts "Fetching: #{url}"
      
      html_content = fetch_page(url)
      if html_content.nil?
        puts "  Failed to fetch #{current_year}, skipping..."
        current_year -= 1
        next
      end

      concerts = parse_setlist_page(html_content, current_year)
      
      # If no concerts found, we've likely reached the earliest year
      if concerts.empty?
        puts "  No shows found for #{current_year}, stopping..."
        break
      end
      
      # Save all shows from this year
      year_saved = 0
      concerts.each do |concert|
        puts "✓ Found show: #{concert[:date]} at #{concert[:venue]}"
        if save_concert_file(concert)
          year_saved += 1
          all_concerts << concert
        end
      end
      
      puts "  Saved #{year_saved}/#{concerts.length} shows from #{current_year}"
      
      # Rate limiting - be respectful to the server
      sleep(2)
      
      current_year -= 1
    end

    puts "\n📊 TOTAL: #{all_concerts.length} shows saved from #{2025 - current_year - 1} years (#{current_year + 1}-2025)"
    all_concerts
  end

  def run
    scrape_all_shows
  end
end

# Run if called directly
if __FILE__ == $PROGRAM_NAME
  scraper = SingleShowScraper.new
  scraper.run
end