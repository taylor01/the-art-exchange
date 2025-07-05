#!/usr/bin/env ruby
# frozen_string_literal: true

# Dave Matthews Band Setlist Scraper
# Extracts complete concert data from https://davematthewsband.com/setlists/
# Generates individual JSON files in format: YYYY_mm_dd_venue_name_city_state_XXXX.json

require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'
require 'date'
require 'optparse'
require 'fileutils'
require 'set'

class DMBSetlistScraper
  BASE_URL = 'https://davematthewsband.com/setlists/'

  def initialize
    @options = {}
    # Determine output directory relative to project root
    script_dir = File.dirname(File.expand_path(__FILE__))
    @output_dir = File.join(script_dir, 'setlists')
    @show_count = 0
    @year_stats = {}
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
    rescue Net::OpenTimeout, Net::ReadTimeout => e
      if retries > 0
        puts "Timeout fetching #{url}, retrying in 3 seconds... (#{retries} retries left)" if @options[:verbose]
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

  def has_setlists?(html_content)
    return false unless html_content

    doc = Nokogiri::HTML(html_content)

    # Check if "no-tours" div is hidden (meaning there are setlists)
    no_tours_div = doc.css('.no-tours').first
    if no_tours_div
      style = no_tours_div['style']
      return style&.include?('display: none')
    end

    # Fallback: look for setlist-content class
    setlist_content = doc.css('.setlist-content')
    setlist_content.any?
  end

  def parse_setlist_page(html_content, year)
    doc = Nokogiri::HTML(html_content)
    concerts = []

    puts "  Parsing setlists for year #{year}..." if @options[:verbose]

    # Look for setlist content - the page contains all setlists for the year
    # Each setlist is in its own section
    setlist_sections = find_setlist_sections(doc)

    puts "  Found #{setlist_sections.length} potential setlist sections" if @options[:verbose]

    setlist_sections.each_with_index do |section, i|
      puts "  Processing setlist #{i + 1}" if @options[:verbose]
      concert = parse_single_setlist(section)
      if concert && concert[:date] && concert[:date].start_with?(year.to_s)
        concerts << concert
      end
    end

    concerts
  end

  def find_setlist_sections(doc)
    # Look for setlist-content class first (primary structure)
    setlist_content = doc.css('.setlist-content')
    if setlist_content.any?
      puts "    Found #{setlist_content.length} setlist-content sections" if @options[:verbose]
      return setlist_content
    end

    # Look for other common selectors
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
        puts "    Using selector: #{selector}" if @options[:verbose]
        return elements
      end
    end

    # Fallback: find elements containing date patterns
    all_elements = doc.css('*')
    date_elements = all_elements.select { |elem| elem.text =~ /\d{2}\.\d{2}\.\d{4}/ }

    puts "    Fallback: found #{date_elements.length} elements with date patterns" if @options[:verbose]

    # Group elements that are likely part of the same setlist
    sections = []
    date_elements.each do |elem|
      # Find the parent container that likely contains the full setlist
      parent = elem
      5.times do
        break unless parent.parent
        parent = parent.parent
        # If this parent contains both a date and multiple lines, it's likely a setlist container
        if parent.text.include?("\n") && parent.text.lines.count > 3
          sections << parent
          break
        end
      end
    end

    sections.uniq
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
      date_match = date_text.match(/(\d{2})\.(\d{2})\.(\d{4})/)
      if date_match
        month, day, year = date_match[1], date_match[2], date_match[3]
        concert[:date] = "#{year}-#{month.rjust(2, '0')}-#{day.rjust(2, '0')}"
      end
    end

    # Extract location from .loc element
    loc_element = section.css('.loc').first
    if loc_element
      concert[:location] = loc_element.text.strip
    end

    # Extract venue from .title h4 element
    title_element = section.css('.title h4').first
    if title_element
      concert[:venue] = title_element.text.strip
    end

    # Parse setlist from .setlist-text ol li elements (this will also extract show notes)
    parse_songs_from_list(section, concert)

    # Validate essential data
    return nil unless concert[:date] && concert[:venue]

    concert
  rescue StandardError => e
    puts "    Error parsing setlist: #{e.message}" if @options[:verbose]
    nil
  end

  def parse_songs_from_list(section, concert)
    puts "  Parsing songs..." if @options[:verbose]
    
    # Extract show notes first to get legend for song parsing
    extract_show_notes(section, concert)
    legend = concert[:show_notes][:legend]
    puts "  Available legend: #{legend}" if @options[:verbose] && legend.any?
    
    # Track which standard symbols we encounter to add to legend
    standard_symbols_found = Set.new
    
    # Parse main set - get only the first <ol> items, not those in .encore-text
    setlist_text = section.css('.setlist-text').first
    if setlist_text
      # Get li elements from the main setlist ol (not from .encore-text ol)
      main_set_items = setlist_text.css('> ol > li')
      puts "    Found #{main_set_items.length} main set items" if @options[:verbose]
      position = 1

      main_set_items.each_with_index do |item, i|
        song_text = item.text.strip
        puts "    Main #{i+1}: '#{song_text}'" if @options[:verbose]
        
        next if should_skip_song_line(song_text)

        song_info = parse_song_line(song_text, legend)
        if song_info[:title].empty?
          puts "      ⚠️  EMPTY TITLE DETECTED for: '#{song_text}'" if @options[:verbose]
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

    # Parse encore from .encore-text
    encore_text = section.css('.encore-text').first
    if encore_text
      encore_items = encore_text.css('li')
      puts "    Found #{encore_items.length} encore items" if @options[:verbose]
      encore_position = 1

      encore_items.each_with_index do |item, i|
        song_text = item.text.strip
        puts "    Encore #{i+1}: '#{song_text}'" if @options[:verbose]
        
        next if should_skip_song_line(song_text)

        song_info = parse_song_line(song_text, legend)
        if song_info[:title].empty?
          puts "      ⚠️  EMPTY TITLE DETECTED for: '#{song_text}'" if @options[:verbose]
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

  def parse_song_line(line, legend = {})
    puts "      Parsing song line: '#{line}'" if @options[:verbose]
    
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
        puts "        Found legend symbol: #{symbol}" if @options[:verbose]
      end
    end

    # Look for inline guest indicators (*text*)
    guest_matches = clean_line.scan(/\*([^*]+)\*/)
    guest_matches.each do |match|
      song[:guests] << match[0].strip
      puts "        Found inline guest: #{match[0].strip}" if @options[:verbose]
    end

    # Look for segue indicators in middle of line (→)
    if clean_line.include?('→') && !clean_line.match(/→\s*$/)
      song[:notes] << "segue"
      puts "        Found inline segue indicator" if @options[:verbose]
    end

    # Look for partial song indicators (parentheses)
    paren_content = []
    if clean_line.match?(/\([^)]+\)/)
      paren_matches = clean_line.scan(/\(([^)]+)\)/)
      paren_matches.each do |match|
        paren_content << match[0]
        song[:notes] << "partial: #{match[0]}"
        puts "        Found partial: #{match[0]}" if @options[:verbose]
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
      puts "        🔧 FIXED: Using partial content as title: '#{clean_title}'" if @options[:verbose]
    end

    song[:title] = clean_title
    puts "        Final clean title: '#{song[:title]}'" if @options[:verbose]
    puts "        Guests: #{song[:guests]}" if @options[:verbose] && song[:guests].any?
    puts "        Notes: #{song[:notes]}" if @options[:verbose] && song[:notes].any?
    puts "        Legend items: #{song[:legend_items]}" if @options[:verbose] && song[:legend_items].any?

    song
  end

  def extract_show_notes(section, concert)
    notes_elements = section.css('.show-notes, .notes, .legend')

    if notes_elements.any?
      notes_text = notes_elements.text.gsub(/\u00A0/, ' ').strip
      puts "  Raw show notes: '#{notes_text}'" if @options[:verbose]
      
      # Parse legend with improved patterns
      parse_legend(notes_text, concert)
      
      # Only add to additional if there's content that wasn't parsed as legend
      remaining_text = remove_legend_items(notes_text)
      if remaining_text && !remaining_text.strip.empty?
        concert[:show_notes][:additional] = remaining_text.strip
        puts "  Remaining notes: '#{remaining_text.strip}'" if @options[:verbose]
      end
    end
  end

  def parse_legend(notes_text, concert)
    puts "    Parsing legend from: '#{notes_text}'" if @options[:verbose]
    
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
      puts "    Found legend (format 1): #{clean_symbol} = #{clean_meaning}" if @options[:verbose]
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
            puts "    Found legend (format 2): #{symbol} = #{meaning}" if @options[:verbose]
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

  def should_skip_song_line(song_text)
    return true if song_text.empty?
    return true if song_text.length < 3
    return true if song_text.downcase.start_with?('show notes')
    return true if song_text.match?(/^[*+→\s]+$/) # Just symbols
    false
  end

  def add_standard_symbols_to_legend(concert, symbols_found)
    standard_meanings = {
      '→' => 'segue'
    }
    
    symbols_found.each do |symbol|
      if standard_meanings[symbol]
        concert[:show_notes][:legend][symbol] = standard_meanings[symbol]
        puts "  Added standard symbol to legend: #{symbol} = #{standard_meanings[symbol]}" if @options[:verbose]
      end
    end
  end

  def sanitize_filename_part(text)
    return 'unknown' unless text && !text.empty?

    # Remove/replace special characters and normalize
    clean = text.downcase
                .gsub(/[^a-z0-9\s]/, ' ')  # Replace special chars with spaces
                .gsub(/\s+/, '_')          # Replace spaces with underscores
                .gsub(/_+/, '_')           # Collapse multiple underscores
                .gsub(/^_|_$/, '')         # Remove leading/trailing underscores

    # Limit length
    clean = clean[0..30] if clean.length > 30

    clean.empty? ? 'unknown' : clean
  end

  def parse_location(location_str)
    return { city: 'unknown', region: 'unknown' } unless location_str

    parts = location_str.split(',').map(&:strip)

    if parts.length >= 2
      city = parts[0]
      region = parts[1]

      # Handle different formats
      if region.length == 2 # US state
        { city: sanitize_filename_part(city), region: sanitize_filename_part(region) }
      else # International or full state name
        { city: sanitize_filename_part(city), region: sanitize_filename_part(region) }
      end
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

    # Find unique filename with 4-digit suffix
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
      puts "    Saved: #{filename}" if @options[:verbose]

      # Print show summary
      main_count = concert[:setlist][:main_set].length
      encore_count = concert[:setlist][:encore].length
      total_count = main_count + encore_count

      puts "    #{concert[:date]} - #{concert[:venue]} - #{concert[:location]}"
      puts "      Main set: #{main_count} songs, Encore: #{encore_count} songs, Total: #{total_count} songs"

      true
    rescue StandardError => e
      puts "    Error saving #{filename}: #{e.message}"
      false
    end
  end

  def scrape_year(year)
    puts "Processing year #{year}..."

    url = "#{BASE_URL}?year=#{year}"
    html_content = fetch_page(url)

    return [] unless html_content

    # Check if this year has any setlists
    unless has_setlists?(html_content)
      puts "  No setlists found for #{year}"
      return []
    end

    concerts = parse_setlist_page(html_content, year)

    year_saved = 0
    concerts.each do |concert|
      if save_concert_file(concert)
        year_saved += 1
        @show_count += 1
      end
    end

    @year_stats[year] = { found: concerts.length, saved: year_saved }
    puts "  Year #{year}: #{concerts.length} shows found, #{year_saved} saved"

    concerts
  end

  def scrape_all_years
    puts "Starting comprehensive DMB setlist scraping (2025 back to 1991 or earlier)..."
    puts "Will stop when a year returns no setlists."

    ensure_output_directory

    start_year = 2025
    current_year = start_year

    # Continue until we find a year with no setlists
    while current_year >= 1985 # Safety limit
      concerts = scrape_year(current_year)

      # If no concerts found, we've likely reached the earliest year
      break if concerts.empty?

      # Rate limiting - be respectful
      sleep(2)

      current_year -= 1
    end

    print_final_statistics
  end

  def print_final_statistics
    puts "\n" + "="*60
    puts "FINAL SCRAPING STATISTICS"
    puts "="*60

    puts "Total shows discovered and saved: #{@show_count}"
    puts "Years processed: #{@year_stats.keys.sort.reverse.join(', ')}"

    if @year_stats.any?
      earliest_year = @year_stats.keys.min
      latest_year = @year_stats.keys.max
      puts "Date range: #{earliest_year} - #{latest_year}"

      puts "\nYear-by-year breakdown:"
      @year_stats.keys.sort.reverse.each do |year|
        stats = @year_stats[year]
        puts "  #{year}: #{stats[:saved]} shows saved (#{stats[:found]} found)"
      end
    end

    puts "\nOutput directory: #{@output_dir}/"

    # Show sample files
    sample_files = Dir.glob(File.join(@output_dir, '*.json')).first(5)
    if sample_files.any?
      puts "\nSample files created:"
      sample_files.each { |file| puts "  #{File.basename(file)}" }
    end

    puts "\nScraping completed successfully!"
  end

  def run(options = {})
    @options = options
    scrape_all_years
  end
end

# Command line interface
if __FILE__ == $PROGRAM_NAME
  options = {}

  OptionParser.new do |opts|
    opts.banner = 'Usage: ruby dmb_setlist_scraper.rb [options]'

    opts.on('-v', '--verbose', 'Verbose output with detailed progress') do
      options[:verbose] = true
    end

    opts.on('-h', '--help', 'Show this help') do
      puts opts
      puts "\nDescription:"
      puts "  Scrapes all Dave Matthews Band setlists from https://davematthewsband.com/setlists/"
      puts "  Creates individual JSON files for each concert in format:"
      puts "  YYYY_mm_dd_venue_name_city_state_XXXX.json"
      puts ""
      puts "  Automatically handles:"
      puts "  - Complete historical data from 2025 back to earliest available (1991+)"
      puts "  - Filename collision prevention with 4-digit unique IDs"
      puts "  - International show locations (city_country format)"
      puts "  - Structured setlists with main_set and encore sections"
      puts "  - Special notations (segues →, guests *, partial songs)"
      puts "  - Legend extraction and show notes"
      puts ""
      puts "Examples:"
      puts "  ruby dmb_setlist_scraper.rb                 # Scrape all shows"
      puts "  ruby dmb_setlist_scraper.rb --verbose       # Show detailed progress"
      puts ""
      puts "Output: Individual JSON files in tools/dmb_scraper/setlists/"
      exit
    end
  end.parse!

  scraper = DMBSetlistScraper.new
  scraper.run(options)
end
