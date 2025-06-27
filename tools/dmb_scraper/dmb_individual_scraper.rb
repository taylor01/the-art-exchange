#!/usr/bin/env ruby
# frozen_string_literal: true

# Dave Matthews Band Individual File Processor
# Processes setlist data and creates individual JSON files with collision-safe naming
# Format: YYYY_mm_dd_venue_name_city_state_XXXX.json

require 'json'
require 'optparse'
require 'fileutils'

class DMBIndividualScraper
  def initialize
    @options = {}
    # Determine directories relative to script location
    script_dir = File.dirname(File.expand_path(__FILE__))
    @input_dir = File.join(script_dir, 'setlists')
    @output_dir = File.join(script_dir, 'setlists')
    @processed_count = 0
    @collision_count = 0
  end

  def ensure_directories
    FileUtils.mkdir_p(@input_dir)
    FileUtils.mkdir_p(@output_dir) if @input_dir != @output_dir
    puts "Input directory: #{@input_dir}/"
    puts "Output directory: #{@output_dir}/" if @input_dir != @output_dir
  end

  def sanitize_filename_part(text)
    return 'unknown' unless text && !text.empty?
    
    # Remove/replace special characters and normalize
    clean = text.downcase
                .gsub(/[^a-z0-9\s]/, ' ')  # Replace special chars with spaces
                .gsub(/\s+/, '_')          # Replace spaces with underscores
                .gsub(/_+/, '_')           # Collapse multiple underscores
                .gsub(/^_|_$/, '')         # Remove leading/trailing underscores
    
    # Limit length to prevent overly long filenames
    clean = clean[0..30] if clean.length > 30
    
    clean.empty? ? 'unknown' : clean
  end

  def parse_location(location_str)
    return { city: 'unknown', region: 'unknown' } unless location_str
    
    parts = location_str.split(',').map(&:strip)
    
    if parts.length >= 2
      city = parts[0]
      region = parts[1]
      
      # Handle different location formats
      if region.length == 2 # US state abbreviation
        { 
          city: sanitize_filename_part(city), 
          region: sanitize_filename_part(region) 
        }
      elsif region.length <= 4 && region.upcase == region # Province abbreviation
        { 
          city: sanitize_filename_part(city), 
          region: sanitize_filename_part(region) 
        }
      else # International or full region name
        { 
          city: sanitize_filename_part(city), 
          region: sanitize_filename_part(region) 
        }
      end
    else
      { 
        city: sanitize_filename_part(parts[0] || 'unknown'), 
        region: 'unknown' 
      }
    end
  end

  def generate_filename(concert_data)
    # Extract date components
    date = concert_data['date'] || concert_data[:date]
    venue = concert_data['venue'] || concert_data[:venue]
    location = concert_data['location'] || concert_data[:location]

    return nil unless date && venue

    # Parse date (assuming YYYY-MM-DD format)
    date_parts = date.split('-')
    return nil unless date_parts.length == 3

    year, month, day = date_parts[0], date_parts[1], date_parts[2]

    # Sanitize venue and location
    venue_clean = sanitize_filename_part(venue)
    location_parts = parse_location(location)

    # Build base filename
    base_name = "#{year}_#{month}_#{day}_#{venue_clean}_#{location_parts[:city]}_#{location_parts[:region]}"

    # Find unique filename with collision prevention
    counter = 1
    loop do
      suffix = counter.to_s.rjust(4, '0')
      filename = "#{base_name}_#{suffix}.json"
      filepath = File.join(@output_dir, filename)

      unless File.exist?(filepath)
        @collision_count += 1 if counter > 1
        return filename
      end
      
      counter += 1
      
      # Safety check to prevent infinite loops
      if counter > 9999
        puts "Warning: Reached maximum collision counter for #{base_name}"
        return "#{base_name}_9999.json"
      end
    end
  end

  def process_concert_data(concert_data, source_file = nil)
    # Ensure the data has the required structure
    processed_data = {
      'band' => 'Dave Matthews Band',
      'date' => concert_data['date'] || concert_data[:date],
      'venue' => concert_data['venue'] || concert_data[:venue],
      'location' => concert_data['location'] || concert_data[:location],
      'setlist' => {
        'main_set' => [],
        'encore' => []
      },
      'show_notes' => {
        'legend' => {}
      },
      'scraped_at' => concert_data['scraped_at'] || concert_data[:scraped_at] || Time.now.iso8601
    }

    # Process setlist data
    if concert_data['setlist'] || concert_data[:setlist]
      setlist = concert_data['setlist'] || concert_data[:setlist]
      
      if setlist['main_set'] || setlist[:main_set]
        processed_data['setlist']['main_set'] = setlist['main_set'] || setlist[:main_set]
      end
      
      if setlist['encore'] || setlist[:encore]
        processed_data['setlist']['encore'] = setlist['encore'] || setlist[:encore]
      end
    end

    # Process legacy song format (flat array)
    if concert_data['songs'] || concert_data[:songs]
      songs = concert_data['songs'] || concert_data[:songs]
      
      # Try to separate main set and encore
      encore_index = songs.find_index { |song| song.to_s.downcase.include?('encore') }
      
      if encore_index
        # Split at encore marker
        main_songs = songs[0...encore_index]
        encore_songs = songs[(encore_index + 1)..-1] || []
        
        processed_data['setlist']['main_set'] = main_songs.map.with_index(1) do |song, pos|
          { 'title' => song, 'position' => pos }
        end
        
        processed_data['setlist']['encore'] = encore_songs.map.with_index(1) do |song, pos|
          { 'title' => song, 'position' => pos }
        end
      else
        # All songs in main set
        processed_data['setlist']['main_set'] = songs.map.with_index(1) do |song, pos|
          { 'title' => song, 'position' => pos }
        end
      end
    end

    # Process show notes
    if concert_data['show_notes'] || concert_data[:show_notes]
      notes = concert_data['show_notes'] || concert_data[:show_notes]
      processed_data['show_notes'].merge!(notes)
    end

    # Add legacy notes if present
    if concert_data['notes'] || concert_data[:notes]
      legacy_notes = concert_data['notes'] || concert_data[:notes]
      processed_data['show_notes']['legacy'] = legacy_notes
    end

    # Add source file reference if provided
    if source_file
      processed_data['source_file'] = File.basename(source_file)
    end

    processed_data
  end

  def save_individual_file(concert_data, source_file = nil)
    processed_data = process_concert_data(concert_data, source_file)
    
    filename = generate_filename(processed_data)
    return false unless filename

    filepath = File.join(@output_dir, filename)

    begin
      File.write(filepath, JSON.pretty_generate(processed_data))
      
      if @options[:verbose]
        main_count = processed_data['setlist']['main_set'].length
        encore_count = processed_data['setlist']['encore'].length
        total_count = main_count + encore_count
        
        puts "  Saved: #{filename}"
        puts "    #{processed_data['date']} - #{processed_data['venue']} - #{processed_data['location']}"
        puts "    Main set: #{main_count} songs, Encore: #{encore_count} songs, Total: #{total_count} songs"
      end

      @processed_count += 1
      true
    rescue StandardError => e
      puts "Error saving #{filename}: #{e.message}"
      false
    end
  end

  def process_json_file(filepath)
    return false unless File.exist?(filepath)

    begin
      content = File.read(filepath)
      data = JSON.parse(content)

      # Handle different data structures
      if data['concerts'] # Master file with multiple concerts
        data['concerts'].each do |concert|
          save_individual_file(concert, filepath)
        end
      elsif data['date'] || data[:date] # Single concert file
        save_individual_file(data, filepath)
      else
        puts "Warning: Unknown JSON structure in #{filepath}"
        return false
      end

      true
    rescue JSON::ParserError => e
      puts "Error parsing JSON file #{filepath}: #{e.message}"
      false
    rescue StandardError => e
      puts "Error processing file #{filepath}: #{e.message}"
      false
    end
  end

  def process_directory
    puts "Processing setlist data files in #{@input_dir}/..."
    
    ensure_directories
    
    # Find all JSON files in the input directory
    json_files = Dir.glob(File.join(@input_dir, '*.json'))
    
    if json_files.empty?
      puts "No JSON files found in #{@input_dir}/"
      puts "Run the main scraper first: ruby dmb_setlist_scraper.rb"
      return false
    end

    puts "Found #{json_files.length} JSON files to process"

    json_files.each do |filepath|
      puts "Processing: #{File.basename(filepath)}" if @options[:verbose]
      process_json_file(filepath)
    end

    print_statistics
    true
  end

  def print_statistics
    puts "\n" + "="*50
    puts "PROCESSING STATISTICS"
    puts "="*50
    puts "Total concerts processed: #{@processed_count}"
    puts "Filename collisions handled: #{@collision_count}"
    puts "Output directory: #{@output_dir}/"

    # Show sample of created files
    output_files = Dir.glob(File.join(@output_dir, '*_*_*_*_*_*_*.json'))
    if output_files.any?
      puts "\nSample individual files created:"
      output_files.first(5).each { |file| puts "  #{File.basename(file)}" }
      puts "  ... and #{output_files.length - 5} more files" if output_files.length > 5
    end

    puts "\nProcessing completed successfully!"
  end

  def run(options = {})
    @options = options
    
    if @options[:input_file]
      # Process single file
      filepath = @options[:input_file]
      unless File.exist?(filepath)
        puts "Error: Input file not found: #{filepath}"
        return false
      end
      
      puts "Processing single file: #{filepath}"
      process_json_file(filepath)
      print_statistics
    else
      # Process directory
      process_directory
    end
  end
end

# Command line interface
if __FILE__ == $PROGRAM_NAME
  options = {}

  OptionParser.new do |opts|
    opts.banner = 'Usage: ruby dmb_individual_scraper.rb [options]'

    opts.on('-i', '--input FILE', 'Process single JSON file instead of directory') do |file|
      options[:input_file] = file
    end

    opts.on('-d', '--directory DIR', 'Input directory (default: tools/dmb_scraper/setlists)') do |dir|
      options[:input_dir] = dir
    end

    opts.on('-o', '--output DIR', 'Output directory (default: same as input)') do |dir|
      options[:output_dir] = dir
    end

    opts.on('-v', '--verbose', 'Verbose output with detailed progress') do
      options[:verbose] = true
    end

    opts.on('-h', '--help', 'Show this help') do
      puts opts
      puts "\nDescription:"
      puts "  Processes DMB setlist JSON files and creates individual concert files"
      puts "  with collision-safe naming in format: YYYY_mm_dd_venue_name_city_state_XXXX.json"
      puts ""
      puts "  Features:"
      puts "  - Handles both master files (multiple concerts) and individual concert files"
      puts "  - Filename collision prevention with 4-digit unique IDs"
      puts "  - International location support (city_country format)"
      puts "  - Structured setlist format with main_set and encore sections"
      puts "  - Preserves all show notes and legends"
      puts ""
      puts "Examples:"
      puts "  ruby dmb_individual_scraper.rb                    # Process all files in default directory"
      puts "  ruby dmb_individual_scraper.rb --verbose          # Show detailed progress"
      puts "  ruby dmb_individual_scraper.rb -i master.json     # Process single file"
      puts "  ruby dmb_individual_scraper.rb -d input/ -o out/  # Custom directories"
      puts ""
      puts "Default input/output: tools/dmb_scraper/setlists/"
      exit
    end
  end.parse!

  scraper = DMBIndividualScraper.new
  scraper.run(options)
end