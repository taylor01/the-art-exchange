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
    rescue Net::TimeoutError, Net::OpenTimeout, Net::ReadTimeout => e
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

    # Parse setlist from .setlist-text ol li elements
    parse_songs_from_list(section, concert)

    # Extract show notes and legend
    extract_show_notes(section, concert)

    # Validate essential data
    return nil unless concert[:date] && concert[:venue]
    
    concert
  rescue StandardError => e
    puts "    Error parsing setlist: #{e.message}" if @options[:verbose]
    nil
  end

  def parse_songs_from_list(section, concert)
    # Parse main set from .setlist-text
    setlist_text = section.css('.setlist-text').first
    if setlist_text
      song_items = setlist_text.css('li')
      position = 1
      
      song_items.each do |item|
        song_text = item.text.strip
        next if song_text.empty?
        next if song_text.length < 3
        next if song_text.downcase.start_with?('show notes')
        next if song_text.match?(/^[*+→\s]+$/) # Just symbols

        song_info = parse_song_line(song_text)
        song_info[:position] = position
        concert[:setlist][:main_set] << song_info
        position += 1
      end
    end

    # Parse encore from .encore-text
    encore_text = section.css('.encore-text').first
    if encore_text
      encore_items = encore_text.css('li')
      encore_position = 1
      
      encore_items.each do |item|
        song_text = item.text.strip
        next if song_text.empty?
        next if song_text.length < 3
        next if song_text.downcase.start_with?('show notes')
        next if song_text.match?(/^[*+→\s]+$/) # Just symbols

        song_info = parse_song_line(song_text)
        song_info[:position] = encore_position
        concert[:setlist][:encore] << song_info
        encore_position += 1
      end
    end
  end

  def parse_song_line(line)
    song = {
      title: line.strip,
      guests: [],
      notes: []
    }

    # Extract and clean special characters while preserving meaning
    original_line = line.dup

    # Look for guest indicators (*)
    if line.include?('*')
      guest_matches = line.scan(/\*([^*]+)\*/)
      guest_matches.each do |match|
        song[:guests] << match[0].strip
      end
      # Clean the asterisks from title but note them
      song[:notes] << "guest performance" if line.include?('*')
    end

    # Look for segue indicators (→)
    if line.include?('→')
      song[:notes] << "segue"
    end

    # Look for partial song indicators (parentheses)
    if line.match?(/\([^)]+\)/)
      paren_content = line.scan(/\(([^)]+)\)/)
      paren_content.each do |match|
        song[:notes] << "partial: #{match[0]}"
      end
    end

    # Clean the title
    clean_title = line.gsub(/\*[^*]*\*/, '').gsub(/→/, '').gsub(/\([^)]*\)/, '').strip
    clean_title = clean_title.gsub(/^\d+[\.\s]*/, '').strip # Remove numbering
    song[:title] = clean_title

    song
  end

  def extract_show_notes(section, concert)
    # Look for legend or show notes sections
    notes_elements = section.css('.show-notes, .notes, .legend')
    
    if notes_elements.any?
      notes_text = notes_elements.text.strip
      concert[:show_notes][:additional] = notes_text unless notes_text.empty?
      
      # Parse legend (e.g., "* = Neil Young")
      legend_matches = notes_text.scan(/([*+→]+)\s*[=:]\s*([^,\n]+)/)
      legend_matches.each do |symbol, meaning|
        concert[:show_notes][:legend][symbol.strip] = meaning.strip
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