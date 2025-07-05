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

  def parse_setlist_page(html_content)
    doc = Nokogiri::HTML(html_content)
    concerts = []

    puts "Parsing setlists for 2018..."

    # Look for setlist content
    setlist_sections = find_setlist_sections(doc)
    puts "Found #{setlist_sections.length} potential setlist sections"

    setlist_sections.each_with_index do |section, i|
      puts "Processing setlist #{i + 1}"
      concert = parse_single_setlist(section)
      
      # Only process the 12-14-2018 show
      if concert && concert[:date] == "2018-12-14"
        concerts << concert
        puts "✓ Found target show: #{concert[:date]} at #{concert[:venue]}"
      elsif concert && concert[:date]
        puts "  Skipping #{concert[:date]} (not our target)"
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

    # Parse setlist songs
    parse_songs_from_list(section, concert)

    # Extract show notes
    extract_show_notes(section, concert)

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
    
    # Parse main set
    setlist_text = section.css('.setlist-text').first
    if setlist_text
      song_items = setlist_text.css('li')
      puts "    Found #{song_items.length} main set items"
      position = 1

      song_items.each_with_index do |item, i|
        song_text = item.text.strip
        puts "    Main #{i+1}: '#{song_text}'"
        
        next if should_skip_song_line(song_text)

        song_info = parse_song_line(song_text)
        if song_info[:title].empty?
          puts "      ⚠️  EMPTY TITLE DETECTED for: '#{song_text}'"
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

        song_info = parse_song_line(song_text)
        if song_info[:title].empty?
          puts "      ⚠️  EMPTY TITLE DETECTED for: '#{song_text}'"
        end
        
        song_info[:position] = encore_position
        concert[:setlist][:encore] << song_info
        encore_position += 1
      end
    end
  end

  def should_skip_song_line(song_text)
    return true if song_text.empty?
    return true if song_text.length < 3
    return true if song_text.downcase.start_with?('show notes')
    return true if song_text.match?(/^[*+→\s]+$/) # Just symbols
    false
  end

  def parse_song_line(line)
    puts "      Parsing song line: '#{line}'"
    
    song = {
      title: line.strip,
      guests: [],
      notes: []
    }

    original_line = line.dup

    # Look for guest indicators (*)
    if line.include?('*')
      guest_matches = line.scan(/\*([^*]+)\*/)
      guest_matches.each do |match|
        song[:guests] << match[0].strip
        puts "        Found guest: #{match[0].strip}"
      end
      song[:notes] << "guest performance" if line.include?('*')
    end

    # Look for segue indicators (→)
    if line.include?('→')
      song[:notes] << "segue"
      puts "        Found segue indicator"
    end

    # Look for partial song indicators (parentheses)
    paren_content = []
    if line.match?(/\([^)]+\)/)
      paren_matches = line.scan(/\(([^)]+)\)/)
      paren_matches.each do |match|
        paren_content << match[0]
        song[:notes] << "partial: #{match[0]}"
        puts "        Found partial: #{match[0]}"
      end
    end

    # Clean the title - THIS IS WHERE THE EMPTY TITLE BUG OCCURS
    clean_title = line.gsub(/\*[^*]*\*/, '')    # Remove *guests*
                     .gsub(/→/, '')              # Remove segue arrows
                     .gsub(/\([^)]*\)/, '')      # Remove (partial) - THIS CAUSES EMPTY TITLES!
                     .strip

    clean_title = clean_title.gsub(/^\d+[\.\s]*/, '').strip # Remove numbering

    # FIX: If title is empty but we found partial content, use the partial as title
    if clean_title.empty? && paren_content.any?
      clean_title = paren_content.first
      puts "        🔧 FIXED: Using partial content as title: '#{clean_title}'"
    end

    song[:title] = clean_title
    puts "        Final title: '#{song[:title]}'"

    song
  end

  def extract_show_notes(section, concert)
    notes_elements = section.css('.show-notes, .notes, .legend')

    if notes_elements.any?
      notes_text = notes_elements.text.strip
      concert[:show_notes][:additional] = notes_text unless notes_text.empty?

      # Parse legend (e.g., "* = Neil Young")
      legend_matches = notes_text.scan(/([*+→]+)\s*[=:]\s*([^,\n]+)/)
      legend_matches.each do |symbol, meaning|
        concert[:show_notes][:legend][symbol.strip] = meaning.strip
        puts "  Found legend: #{symbol.strip} = #{meaning.strip}"
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

  def scrape_target_show
    puts "🎯 Targeting 12-14-2018 show specifically"
    ensure_output_directory

    url = "#{BASE_URL}?year=2018"
    puts "Fetching: #{url}"
    
    html_content = fetch_page(url)
    return [] unless html_content

    concerts = parse_setlist_page(html_content)

    if concerts.any?
      concert = concerts.first
      puts "\n🎵 FOUND TARGET SHOW!"
      save_concert_file(concert)
    else
      puts "❌ Could not find 12-14-2018 show"
    end

    concerts
  end

  def run
    scrape_target_show
  end
end

# Run if called directly
if __FILE__ == $PROGRAM_NAME
  scraper = SingleShowScraper.new
  scraper.run
end