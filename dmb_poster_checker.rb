#!/usr/bin/env ruby
# frozen_string_literal: true

# DMB Poster Coverage Checker
# Analyzes all JSON files in dmb_setlists/ and reports poster matching statistics

require 'json'
require 'optparse'

# Rails integration for poster matching
begin
  require_relative 'config/environment'
  RAILS_AVAILABLE = true
rescue LoadError
  puts "Error: Rails environment not found. Make sure you're running this from the Rails app directory."
  exit 1
end

class DMBPosterChecker
  def initialize
    @options = {}
    @setlists_dir = 'dmb_setlists'
    @dmb_band = nil
    @poster_cache = {}
    @stats = {
      total_files: 0,
      parsed_files: 0,
      concerts_with_dates: 0,
      concerts_with_posters: 0,
      total_poster_matches: 0,
      years_covered: {},
      decade_stats: {},
      missing_poster_dates: []
    }
  end

  def load_poster_cache
    @dmb_band = Band.find_by(name: "Dave Matthews Band")

    unless @dmb_band
      puts "Error: Dave Matthews Band not found in database"
      exit 1
    end

    puts "Found Dave Matthews Band in database (ID: #{@dmb_band.id})"

    # Load all DMB posters into memory for fast matching
    @dmb_band.posters.each do |poster|
      next unless poster.release_date

      # Convert poster date to YYYY-MM-DD format to match setlist format
      date_key = poster.release_date.strftime('%Y-%m-%d')
      @poster_cache[date_key] ||= []
      @poster_cache[date_key] << {
        id: poster.id,
        name: poster.name,
        venue: poster.venue&.name,
        release_date: date_key,
        slug: poster.slug
      }
    end

    puts "Loaded #{@poster_cache.keys.length} unique poster dates for matching"
    puts "Total posters: #{@poster_cache.values.flatten.length}"
    puts ""
  end

  def check_setlists_directory
    unless Dir.exist?(@setlists_dir)
      puts "Error: #{@setlists_dir} directory not found"
      puts "Run the scraper first: ruby dmb_individual_scraper.rb --historical"
      exit 1
    end

    json_files = Dir.glob(File.join(@setlists_dir, '*.json'))
    @stats[:total_files] = json_files.length

    if json_files.empty?
      puts "Error: No JSON files found in #{@setlists_dir}/"
      puts "Run the scraper first: ruby dmb_individual_scraper.rb --historical"
      exit 1
    end

    puts "Found #{json_files.length} JSON files in #{@setlists_dir}/"
    puts ""

    json_files
  end

  def parse_concert_file(filepath)
    begin
      data = JSON.parse(File.read(filepath), symbolize_names: true)
      @stats[:parsed_files] += 1

      # Basic validation
      unless data[:date] && data[:band] == "Dave Matthews Band"
        puts "  Warning: Invalid concert data in #{File.basename(filepath)}" if @options[:verbose]
        return nil
      end

      @stats[:concerts_with_dates] += 1

      # Track year statistics
      year = data[:date].split('-')[0].to_i
      decade = (year / 10) * 10

      @stats[:years_covered][year] ||= 0
      @stats[:years_covered][year] += 1

      @stats[:decade_stats][decade] ||= { concerts: 0, with_posters: 0 }
      @stats[:decade_stats][decade][:concerts] += 1

      data
    rescue JSON::ParserError => e
      puts "  Error parsing #{File.basename(filepath)}: #{e.message}" if @options[:verbose]
      nil
    rescue StandardError => e
      puts "  Error reading #{File.basename(filepath)}: #{e.message}" if @options[:verbose]
      nil
    end
  end

  def find_matching_posters(concert_date)
    return [] unless concert_date && @poster_cache

    matching_posters = @poster_cache[concert_date] || []
    matching_posters
  end

  def check_poster_coverage
    puts "Checking poster coverage..."
    puts ""

    json_files = check_setlists_directory

    json_files.each_with_index do |filepath, index|
      concert = parse_concert_file(filepath)
      next unless concert

      posters = find_matching_posters(concert[:date])

      if posters.any?
        @stats[:concerts_with_posters] += 1
        @stats[:total_poster_matches] += posters.length

        # Update decade stats
        year = concert[:date].split('-')[0].to_i
        decade = (year / 10) * 10
        @stats[:decade_stats][decade][:with_posters] += 1

        if @options[:verbose]
          puts "✓ #{concert[:date]} - #{concert[:venue]}: #{posters.length} poster(s)"
          posters.each { |p| puts "    - #{p[:name]}" } if @options[:detailed]
        end
      else
        @stats[:missing_poster_dates] << {
          date: concert[:date],
          venue: concert[:venue],
          location: concert[:location]
        }

        if @options[:verbose]
          puts "✗ #{concert[:date]} - #{concert[:venue]}: no posters"
        end
      end

      # Progress indicator
      if (index + 1) % 100 == 0
        puts "  Processed #{index + 1}/#{json_files.length} files..."
      end
    end
  end

  def generate_report
    puts "\n" + "="*60
    puts "DMB POSTER COVERAGE REPORT"
    puts "="*60

    # Overall statistics
    puts "\nOVERALL STATISTICS:"
    puts "Total JSON files: #{@stats[:total_files]}"
    puts "Successfully parsed: #{@stats[:parsed_files]}"
    puts "Valid concerts: #{@stats[:concerts_with_dates]}"
    puts "Concerts with posters: #{@stats[:concerts_with_posters]}"
    puts "Total poster matches: #{@stats[:total_poster_matches]}"

    if @stats[:concerts_with_dates] > 0
      coverage_pct = (@stats[:concerts_with_posters].to_f / @stats[:concerts_with_dates] * 100).round(2)
      puts "Coverage percentage: #{coverage_pct}%"
    end

    # Year range
    if @stats[:years_covered].any?
      years = @stats[:years_covered].keys.sort
      puts "Year range: #{years.first}-#{years.last}"
      puts "Years with concerts: #{@stats[:years_covered].keys.length}"
    end

    # Decade breakdown
    puts "\nDECADE BREAKDOWN:"
    @stats[:decade_stats].keys.sort.each do |decade|
      stats = @stats[:decade_stats][decade]
      coverage = stats[:concerts] > 0 ? (stats[:with_posters].to_f / stats[:concerts] * 100).round(1) : 0
      puts "#{decade}s: #{stats[:with_posters]}/#{stats[:concerts]} concerts (#{coverage}%)"
    end

    # Top years with most concerts
    puts "\nTOP YEARS BY CONCERT COUNT:"
    @stats[:years_covered].sort_by { |year, count| -count }.first(10).each do |year, count|
      puts "#{year}: #{count} concerts"
    end

    # Missing poster opportunities
    if @options[:show_missing] && @stats[:missing_poster_dates].any?
      puts "\nCONCERTS WITHOUT POSTERS (sample):"
      @stats[:missing_poster_dates].first(20).each do |concert|
        puts "#{concert[:date]} - #{concert[:venue]} (#{concert[:location]})"
      end

      if @stats[:missing_poster_dates].length > 20
        puts "... and #{@stats[:missing_poster_dates].length - 20} more"
      end
    end

    puts "\n" + "="*60
  end

  def run(options = {})
    @options = options

    puts "DMB Poster Coverage Checker"
    puts "Loading poster data from Rails database..."
    load_poster_cache

    check_poster_coverage
    generate_report

    puts "\nAnalysis complete!"
  end
end

# Command line interface
if __FILE__ == $PROGRAM_NAME
  options = {}

  OptionParser.new do |opts|
    opts.banner = 'Usage: ruby dmb_poster_checker.rb [options]'

    opts.on('-v', '--verbose', 'Show detailed progress for each concert') do
      options[:verbose] = true
    end

    opts.on('-d', '--detailed', 'Show individual poster names (requires --verbose)') do
      options[:detailed] = true
    end

    opts.on('-m', '--show-missing', 'Show sample of concerts without posters') do
      options[:show_missing] = true
    end

    opts.on('-h', '--help', 'Show this help') do
      puts opts
      puts "\nExamples:"
      puts "  ruby dmb_poster_checker.rb                # Basic coverage report"
      puts "  ruby dmb_poster_checker.rb -v             # Detailed progress"
      puts "  ruby dmb_poster_checker.rb -v -d          # Show poster names"
      puts "  ruby dmb_poster_checker.rb -m             # Include missing concerts list"
      puts "  ruby dmb_poster_checker.rb -v -m          # Full detailed report"
      puts "\nRequires: dmb_setlists/ directory with JSON files from dmb_individual_scraper.rb"
      exit
    end
  end.parse!

  checker = DMBPosterChecker.new
  checker.run(options)
end
