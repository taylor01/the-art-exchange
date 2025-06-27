#!/usr/bin/env ruby
# frozen_string_literal: true

# Dave Matthews Band Individual Show Scraper
# Downloads each show as a separate JSON file to avoid rate limiting

require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'
require 'date'
require 'optparse'
require 'fileutils'

class DMBIndividualScraper
  BASE_URL = 'https://davematthewsband.com/setlists/'

  def initialize
    @options = {}
    @output_dir = 'dmb_setlists'
  end

  def ensure_output_directory
    FileUtils.mkdir_p(@output_dir)
    puts "Output directory: #{@output_dir}/"
  end

  def fetch_page_with_fresh_connection(url, retries = 3)
    uri = URI(url)
    
    # Create a fresh connection for each request to avoid rate limiting
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.open_timeout = 15
    http.read_timeout = 45
    
    begin
      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
      
      response = http.request(request)
      
      if response.code.to_i == 200
        response.body
      else
        puts "Error fetching #{url}: HTTP #{response.code}"
        nil
      end
    rescue Net::TimeoutError, Net::OpenTimeout, Net::ReadTimeout => e
      if retries > 0
        puts "Timeout fetching #{url}, retrying in 5 seconds... (#{retries} retries left)"
        sleep(5)
        fetch_page_with_fresh_connection(url, retries - 1)
      else
        puts "Failed to fetch #{url} after multiple retries: #{e.message}"
        nil
      end
    rescue StandardError => e
      puts "Error fetching #{url}: #{e.message}"
      nil
    ensure
      # Always close the connection
      http.finish if http.started?
    end
  end

  def parse_setlist_page(html_content)
    doc = Nokogiri::HTML(html_content)
    concerts = []

    puts "DEBUG: Looking for concert entries..." if @options[:verbose]

    # Look for tour date items
    entries = doc.css('.tour-date-item')
    
    if entries.empty?
      puts "DEBUG: No .tour-date-item found, trying fallback selectors..." if @options[:verbose]
      entries = doc.css('*').select { |elem| elem.text =~ /\d{2}\.\d{2}\.\d{4}/ }
    end

    puts "DEBUG: Found #{entries.length} potential concert entries" if @options[:verbose]

    entries.each_with_index do |entry, i|
      puts "DEBUG: Processing entry #{i + 1}" if @options[:verbose]
      concert = parse_single_concert(entry)
      concerts << concert if concert
    end

    concerts
  end

  def parse_single_concert(entry)
    concert = {
      band: 'Dave Matthews Band',
      date: nil,
      venue: nil,
      location: nil,
      songs: [],
      notes: {},
      scraped_at: Time.now.iso8601
    }

    # Extract date and convert to YYYY-MM-DD format
    raw_date = nil
    date_element = entry.css('.concert-date').first
    if date_element
      raw_date = date_element.text.strip
    else
      date_match = entry.text.match(/(\d{2}\.\d{2}\.\d{4})/)
      raw_date = date_match[1] if date_match
    end
    
    # Convert MM.DD.YYYY to YYYY-MM-DD
    if raw_date
      parts = raw_date.split('.')
      if parts.length == 3
        month, day, year = parts
        concert[:date] = "#{year}-#{month.rjust(2, '0')}-#{day.rjust(2, '0')}"
      end
    end

    # Extract venue and location from text content
    text_lines = entry.text.split("\n").map(&:strip).reject(&:empty?)
    
    date_line_index = text_lines.find_index { |line| line.match?(/\d{2}\.\d{2}\.\d{4}/) }
    
    if date_line_index && date_line_index < text_lines.length - 2
      next_line_index = date_line_index + 1
      while next_line_index < text_lines.length && text_lines[next_line_index].empty?
        next_line_index += 1
      end
      
      if next_line_index < text_lines.length
        potential_venue = text_lines[next_line_index]
        concert[:venue] = potential_venue unless potential_venue.match?(/\d{2}\.\d{2}\.\d{4}/)
        
        location_line_index = next_line_index + 1
        if location_line_index < text_lines.length
          potential_location = text_lines[location_line_index]
          if potential_location.include?(',') && !potential_location.match?(/\d{2}\.\d{2}\.\d{4}/)
            concert[:location] = potential_location
          end
        end
      end
    end

    # Extract songs
    song_selectors = ['.setlist ol li', '.setlist ul li', 'ol li', 'ul li', '.songs li']
    
    song_selectors.each do |selector|
      entry.css(selector).each do |li|
        song_text = li.text.strip
        next if song_text.empty? || song_text.match?(/^\d+\.$/)
        
        concert[:songs] << song_text
      end
      break unless concert[:songs].empty?
    end

    # Extract show notes
    show_notes = entry.css('.show-notes, .notes')
    if show_notes.any?
      notes_text = show_notes.text
      if notes_text.include?('guest') || notes_text.include?('with')
        guests = extract_guests(notes_text)
        concert[:notes][:guests] = guests unless guests.empty?
      end
      
      concert[:notes][:additional] = notes_text.strip unless notes_text.strip.empty?
    end

    if @options[:verbose]
      puts "DEBUG: Extracted - Date: #{concert[:date]}, Venue: #{concert[:venue]}, Songs: #{concert[:songs].length}"
    end

    # Only return if we have essential data
    return concert if concert[:date] && (concert[:venue] || !concert[:songs].empty?)

    nil
  rescue StandardError => e
    puts "Error parsing concert entry: #{e.message}"
    nil
  end

  def extract_guests(text)
    guests = []
    
    guest_patterns = [
      /guest[:\s]+([^\.]+)/i,
      /with[:\s]+([^\.]+)/i,
      /featuring[:\s]+([^\.]+)/i
    ]

    guest_patterns.each do |pattern|
      matches = text.scan(pattern)
      matches.each do |match|
        guest_name = match[0].strip.gsub(/[,\.]$/, '')
        guests << guest_name unless guest_name.empty?
      end
    end

    guests.uniq
  end

  def generate_filename(concert_date)
    return nil unless concert_date
    
    # Date is already in YYYY-MM-DD format
    "dmb_#{concert_date}.json"
  end

  def file_exists?(concert_date)
    filename = generate_filename(concert_date)
    return false unless filename
    
    File.exist?(File.join(@output_dir, filename))
  end

  def save_concert_file(concert)
    return false unless concert[:date]
    
    filename = generate_filename(concert[:date])
    return false unless filename
    
    filepath = File.join(@output_dir, filename)
    
    # Check if file already exists
    if File.exist?(filepath)
      puts "  File already exists: #{filename}" if @options[:verbose]
      return false
    end
    
    begin
      File.write(filepath, JSON.pretty_generate(concert))
      puts "  Saved: #{filename}" if @options[:verbose]
      true
    rescue StandardError => e
      puts "  Error saving #{filename}: #{e.message}"
      false
    end
  end

  def scrape_historical_setlists(limit = nil)
    puts 'Fetching complete Dave Matthews Band setlist history (1999-2025)...'
    puts 'Each show will be saved as an individual JSON file.'
    puts 'Press Ctrl+C to stop at any time.'
    
    ensure_output_directory
    
    total_processed = 0
    total_saved = 0
    start_year = @options[:start_year] || 2025
    interrupted = false
    
    # Handle interruption gracefully
    trap('INT') do
      puts "\nInterrupted! Progress has been saved as individual files."
      interrupted = true
    end
    
    # Iterate through years (newest first)
    (1999..start_year).reverse_each do |year|
      break if interrupted
      
      puts "Processing year #{year}..."
      year_concerts = 0
      year_saved = 0
      
      # Iterate through months
      (1..12).each do |month|
        break if interrupted
        
        puts "  Fetching #{year}-#{month.to_s.rjust(2, '0')}..." if @options[:verbose]
        
        # Construct URL with year/month filters
        url = "#{BASE_URL}?year=#{year}&month=#{month}"
        
        html_content = fetch_page_with_fresh_connection(url)
        next unless html_content
        
        concerts = parse_setlist_page(html_content)
        
        # Filter concerts to only include those from the requested year/month
        filtered_concerts = concerts.select do |concert|
          if concert[:date]
            concert_year = concert[:date].split('-')[0].to_i
            concert_month = concert[:date].split('-')[1].to_i
            concert_year == year && concert_month == month
          else
            false
          end
        end
        
        if filtered_concerts.empty?
          puts "    No concerts found for #{year}-#{month.to_s.rjust(2, '0')}" if @options[:verbose]
        else
          puts "    Found #{filtered_concerts.length} concerts for #{year}-#{month.to_s.rjust(2, '0')}" if @options[:verbose]
        end
        
        filtered_concerts.each do |concert|
          total_processed += 1
          year_concerts += 1
          
          # Skip if file already exists
          if file_exists?(concert[:date])
            puts "    Skipping #{concert[:date]} (file exists)" if @options[:verbose]
            next
          end
          
          if save_concert_file(concert)
            total_saved += 1
            year_saved += 1
            puts "    Saved #{concert[:date]} - #{concert[:venue]}" if @options[:verbose]
          end
          
          # Check limit
          if limit && total_saved >= limit
            puts "Reached limit of #{limit} concerts"
            interrupted = true
            break
          end
        end
        
        # Rate limiting - close connection and wait
        if @options[:verbose] && filtered_concerts.any?
          saved_count = filtered_concerts.count { |c| !file_exists?(c[:date]) }
          puts "    Saved #{saved_count} new files for #{year}-#{month.to_s.rjust(2, '0')}"
        end
        sleep(2) # Wait between requests to be respectful
        
        break if interrupted
      end
      
      puts "Year #{year}: #{year_concerts} shows found, #{year_saved} new files saved"
      
      break if interrupted
    end
    
    puts "\nScraping Summary:"
    puts "Total shows processed: #{total_processed}"
    puts "New files saved: #{total_saved}"
    puts "Output directory: #{@output_dir}/"
    
    # Show some sample files
    sample_files = Dir.glob(File.join(@output_dir, '*.json')).first(3)
    if sample_files.any?
      puts "\nSample files created:"
      sample_files.each { |file| puts "  #{File.basename(file)}" }
    end
  end

  def run(options = {})
    @options = options
    
    if @options[:historical]
      scrape_historical_setlists(@options[:limit])
    else
      puts "Use --historical flag to scrape all shows"
      puts "Example: ruby dmb_individual_scraper.rb --historical --verbose"
    end
  end
end

# Command line interface
if __FILE__ == $PROGRAM_NAME
  options = {}
  
  OptionParser.new do |opts|
    opts.banner = 'Usage: ruby dmb_individual_scraper.rb [options]'
    
    opts.on('-l', '--limit NUMBER', Integer, 'Limit number of concerts to scrape') do |limit|
      options[:limit] = limit
    end
    
    opts.on('-v', '--verbose', 'Verbose output') do
      options[:verbose] = true
    end
    
    opts.on('--historical', 'Scrape complete historical archive (1999-2025)') do
      options[:historical] = true
    end
    
    opts.on('--start-year YEAR', Integer, 'Start scraping from specific year (for resuming)') do |year|
      options[:start_year] = year
    end
    
    opts.on('-h', '--help', 'Show this help') do
      puts opts
      puts "\nExamples:"
      puts "  ruby dmb_individual_scraper.rb --historical       # Scrape all shows to individual files"
      puts "  ruby dmb_individual_scraper.rb --historical --limit 50  # First 50 shows only"
      puts "  ruby dmb_individual_scraper.rb --historical --verbose   # Show detailed progress"
      puts "  ruby dmb_individual_scraper.rb --historical --start-year 2010 # Resume from 2010"
      puts "\nOutput: Individual JSON files saved to dmb_setlists/ directory"
      puts "Format: dmb_YYYY-MM-DD.json (e.g., dmb_2004-06-17.json)"
      exit
    end
  end.parse!

  scraper = DMBIndividualScraper.new
  scraper.run(options)
end