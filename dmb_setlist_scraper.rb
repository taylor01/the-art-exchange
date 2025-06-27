#!/usr/bin/env ruby
# frozen_string_literal: true

# Dave Matthews Band Setlist Scraper
# Extracts concert data from https://davematthewsband.com/setlists/ and converts to JSON

require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'
require 'date'
require 'optparse'

class DMBSetlistScraper
  BASE_URL = 'https://davematthewsband.com/setlists/'

  def initialize
    @options = {}
  end

  def fetch_page(url)
    uri = URI(url)
    
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
      
      response = http.request(request)
      
      if response.code.to_i == 200
        response.body
      else
        puts "Error fetching #{url}: HTTP #{response.code}"
        nil
      end
    end
  rescue StandardError => e
    puts "Error fetching #{url}: #{e.message}"
    nil
  end

  def parse_setlist_page(html_content)
    doc = Nokogiri::HTML(html_content)
    concerts = []

    # Debug: show what we're working with
    puts "DEBUG: Looking for concert entries..." if @options[:verbose]

    # Try multiple selectors for concert entries
    selectors = [
      '.tour-date-item',
      '.setlist-item', 
      '.concert-entry',
      'article',
      '.show-item'
    ]

    entries = []
    selectors.each do |selector|
      entries = doc.css(selector)
      puts "DEBUG: Found #{entries.length} entries with selector '#{selector}'" if @options[:verbose]
      break unless entries.empty?
    end
    
    # Fallback: look for any element containing date patterns
    if entries.empty?
      entries = doc.css('*').select { |elem| elem.text =~ /\d{2}\.\d{2}\.\d{4}/ }
      puts "DEBUG: Fallback found #{entries.length} elements with date patterns" if @options[:verbose]
    end

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
      notes: {}
    }

    # Debug: show entry content
    if @options[:verbose]
      puts "DEBUG: Entry HTML classes: #{entry['class']}"
      puts "DEBUG: Entry text preview: #{entry.text.strip[0..100]}..."
    end

    # Extract date from .concert-date or text pattern
    date_element = entry.css('.concert-date').first
    if date_element
      concert[:date] = date_element.text.strip
    else
      # Fallback: look for date pattern in text
      date_match = entry.text.match(/(\d{2}\.\d{2}\.\d{4})/)
      concert[:date] = date_match[1] if date_match
    end

    # Extract venue and location from text content
    text_lines = entry.text.split("\n").map(&:strip).reject(&:empty?)
    
    # Find venue and location after date
    date_line_index = text_lines.find_index { |line| line.match?(/\d{2}\.\d{2}\.\d{4}/) }
    
    if date_line_index && date_line_index < text_lines.length - 2
      # Skip empty lines and find venue/location
      next_line_index = date_line_index + 1
      while next_line_index < text_lines.length && text_lines[next_line_index].empty?
        next_line_index += 1
      end
      
      if next_line_index < text_lines.length
        potential_venue = text_lines[next_line_index]
        concert[:venue] = potential_venue unless potential_venue.match?(/\d{2}\.\d{2}\.\d{4}/)
        
        # Look for location in next line
        location_line_index = next_line_index + 1
        if location_line_index < text_lines.length
          potential_location = text_lines[location_line_index]
          if potential_location.include?(',') && !potential_location.match?(/\d{2}\.\d{2}\.\d{4}/)
            concert[:location] = potential_location
          end
        end
      end
    end

    # Extract songs from setlist - try multiple selectors
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
      
      # Add any other notes
      concert[:notes][:additional] = notes_text.strip unless notes_text.strip.empty?
    end

    # Debug: show what we extracted
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
    
    # Look for common guest patterns
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

  def scrape_setlists(limit = nil)
    puts 'Fetching Dave Matthews Band setlists...'
    
    html_content = fetch_page(BASE_URL)
    return [] unless html_content

    concerts = parse_setlist_page(html_content)
    concerts = concerts.first(limit) if limit

    # Sort by date (newest first)
    concerts.sort_by! { |concert| concert[:date] || '' }.reverse!
    
    concerts
  end

  def save_to_json(concerts, filename = 'dmb_setlists.json')
    data = {
      scraped_at: Time.now.iso8601,
      total_concerts: concerts.length,
      concerts: concerts
    }

    File.write(filename, JSON.pretty_generate(data))
    puts "Saved #{concerts.length} concerts to #{filename}"
    true
  rescue StandardError => e
    puts "Error saving to JSON: #{e.message}"
    false
  end

  def run(options = {})
    @options = options
    
    concerts = scrape_setlists(@options[:limit])
    
    if concerts.any?
      save_to_json(concerts, @options[:output] || 'dmb_setlists.json')
      
      if @options[:verbose]
        puts "\nSample concert data:"
        puts JSON.pretty_generate(concerts.first)
      end
    else
      puts 'No concerts found. The website structure may have changed.'
    end
  end
end

# Command line interface
if __FILE__ == $PROGRAM_NAME
  options = {}
  
  OptionParser.new do |opts|
    opts.banner = 'Usage: ruby dmb_setlist_scraper.rb [options]'
    
    opts.on('-l', '--limit NUMBER', Integer, 'Limit number of concerts to scrape') do |limit|
      options[:limit] = limit
    end
    
    opts.on('-o', '--output FILENAME', 'Output JSON filename') do |filename|
      options[:output] = filename
    end
    
    opts.on('-v', '--verbose', 'Verbose output') do
      options[:verbose] = true
    end
    
    opts.on('-h', '--help', 'Show this help') do
      puts opts
      exit
    end
  end.parse!

  scraper = DMBSetlistScraper.new
  scraper.run(options)
end