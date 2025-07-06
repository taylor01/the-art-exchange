class SetlistVenueAnalyzer
  attr_reader :analysis_results

  def initialize
    @setlist_directory = Rails.root.join("tools", "dmb_scraper", "setlists")
    @analysis_results = {}
  end

  def analyze_all_setlists
    puts "🔍 Starting comprehensive setlist venue analysis..."
    
    # Step 1: Extract all venue/location combinations
    puts "📊 Step 1: Extracting venue/location combinations from #{count_setlist_files} files..."
    venue_combinations = extract_venues_from_setlists
    puts "   Found #{venue_combinations.size} unique venue/location combinations"
    
    # Step 2: Match against venue research data
    puts "🎯 Step 2: Matching against venue research database..."
    categorized_matches = categorize_venue_matches(venue_combinations)
    
    # Step 3: Generate comprehensive mapping
    puts "📋 Step 3: Generating venue mapping analysis..."
    @analysis_results = generate_venue_mapping(categorized_matches)
    
    # Step 4: Write analysis to JSON file
    output_file = Rails.root.join("venue_mapping_analysis.json")
    puts "💾 Step 4: Writing analysis to #{output_file}..."
    File.write(output_file, JSON.pretty_generate(@analysis_results))
    
    # Step 5: Display summary
    display_analysis_summary
    
    puts "✅ Analysis complete! Review #{output_file} for detailed mappings."
    @analysis_results
  end

  private

  def count_setlist_files
    Dir.glob(@setlist_directory.join("*.json")).size
  end

  def extract_venues_from_setlists
    venue_combinations = {}
    
    Dir.glob(@setlist_directory.join("*.json")).each_with_index do |file_path, index|
      begin
        data = JSON.parse(File.read(file_path))
        venue_name = data["venue"]
        location = data["location"]
        date = data["date"]
        
        if venue_name.present? && location.present?
          key = "#{venue_name}|#{location}"
          venue_combinations[key] ||= {
            venue_name: venue_name,
            location: location,
            setlist_files: [],
            show_dates: []
          }
          
          venue_combinations[key][:setlist_files] << File.basename(file_path)
          venue_combinations[key][:show_dates] << date if date.present?
        end
        
        # Progress indicator
        if (index + 1) % 100 == 0
          print "."
        end
      rescue => e
        puts "\n⚠️  Error reading #{file_path}: #{e.message}"
      end
    end
    
    puts "\n"
    venue_combinations
  end

  def categorize_venue_matches(venue_combinations)
    results = {
      exact_matches: [],
      fuzzy_matches: [],
      new_venues: [],
      ambiguous_cases: []
    }

    venue_combinations.each do |key, combo|
      venue_name = combo[:venue_name]
      location = combo[:location]
      city, state = parse_location(location)
      
      # Try exact match against venue_names table
      exact_match = find_exact_venue_match(venue_name, city, state)
      
      if exact_match
        results[:exact_matches] << {
          **combo,
          matched_venue: exact_match[:venue],
          matched_historical_name: exact_match[:historical_name],
          confidence: 100,
          match_type: "exact_historical_name"
        }
      else
        # Try fuzzy match
        fuzzy_match = find_fuzzy_venue_match(venue_name, city, state)
        
        if fuzzy_match && fuzzy_match[:similarity] >= 0.8
          results[:fuzzy_matches] << {
            **combo,
            matched_venue: fuzzy_match[:venue],
            matched_historical_name: fuzzy_match[:historical_name],
            confidence: (fuzzy_match[:similarity] * 100).round,
            similarity_score: fuzzy_match[:similarity],
            match_type: "fuzzy_historical_name"
          }
        else
          # Check if we have ANY venues in this city
          existing_venues_in_city = find_venues_in_city(city, state)
          
          if existing_venues_in_city.any?
            # Ambiguous case - venues exist but no good match
            results[:ambiguous_cases] << {
              **combo,
              potential_matches: existing_venues_in_city.map { |v| 
                {
                  venue_id: v.id,
                  venue_name: v.name,
                  similarity_score: calculate_similarity(venue_name, v.name)
                }
              },
              match_type: "requires_claude_consultation"
            }
          else
            # New venue needed
            results[:new_venues] << {
              **combo,
              match_type: "new_venue_required",
              reason: "No existing venues found in #{city}, #{state}"
            }
          end
        end
      end
    end

    results
  end

  def find_exact_venue_match(venue_name, city, state)
    return nil unless city.present? && state.present?

    # Query venue_names for exact match
    venue_name_record = VenueName.joins(:venue)
      .where("LOWER(venue_names.name) = ?", venue_name.downcase.strip)
      .where("LOWER(venues.city) = ? AND LOWER(venues.administrative_area) = ?", 
             city.downcase, state.downcase)
      .first

    if venue_name_record
      {
        venue: venue_name_record.venue,
        historical_name: venue_name_record.name,
        venue_name_record: venue_name_record
      }
    end
  end

  def find_fuzzy_venue_match(venue_name, city, state)
    return nil unless city.present? && state.present?

    # Use PostgreSQL trigram similarity for fuzzy matching
    venue_name_record = VenueName.joins(:venue)
      .where("venues.city ILIKE ? AND venues.administrative_area ILIKE ?", city, state)
      .where("similarity(venue_names.name, ?) > 0.6", venue_name)
      .order(Arel.sql("similarity(venue_names.name, #{ActiveRecord::Base.connection.quote(venue_name)}) DESC"))
      .first

    if venue_name_record
      similarity = ActiveRecord::Base.connection.execute(
        "SELECT similarity(#{ActiveRecord::Base.connection.quote(venue_name_record.name)}, #{ActiveRecord::Base.connection.quote(venue_name)})"
      ).first["similarity"].to_f

      {
        venue: venue_name_record.venue,
        historical_name: venue_name_record.name,
        venue_name_record: venue_name_record,
        similarity: similarity
      }
    end
  end

  def find_venues_in_city(city, state)
    return [] unless city.present? && state.present?
    
    Venue.where("LOWER(city) = ? AND LOWER(administrative_area) = ?", 
                city.downcase, state.downcase)
         .includes(:venue_names)
         .limit(10) # Limit for performance
  end

  def calculate_similarity(name1, name2)
    return 0.0 unless name1.present? && name2.present?
    
    result = ActiveRecord::Base.connection.execute(
      "SELECT similarity(#{ActiveRecord::Base.connection.quote(name1)}, #{ActiveRecord::Base.connection.quote(name2)})"
    ).first
    
    result["similarity"].to_f
  end

  def parse_location(location_string)
    return [nil, nil] unless location_string.present?

    parts = location_string.split(',').map(&:strip)
    case parts.length
    when 2
      [parts[0], parts[1]]
    when 1
      [parts[0], nil]
    else
      [parts[0], parts[1]]
    end
  end

  def generate_venue_mapping(categorized_matches)
    {
      analysis_metadata: {
        generated_at: Time.current.iso8601,
        total_setlists_analyzed: count_setlist_files,
        unique_venue_location_combinations: categorized_matches.values.map(&:size).sum,
        venue_research_data_version: Time.current.strftime("%Y-%m-%d"),
        analyzer_version: "1.0.0"
      },
      category_summary: {
        exact_matches: categorized_matches[:exact_matches].size,
        fuzzy_matches: categorized_matches[:fuzzy_matches].size,
        new_venues: categorized_matches[:new_venues].size,
        ambiguous_cases: categorized_matches[:ambiguous_cases].size
      },
      venue_mappings: {
        exact_matches: categorized_matches[:exact_matches].map { |match| format_exact_match(match) },
        fuzzy_matches: categorized_matches[:fuzzy_matches].map { |match| format_fuzzy_match(match) },
        new_venues: categorized_matches[:new_venues].map { |match| format_new_venue(match) },
        ambiguous_cases: categorized_matches[:ambiguous_cases].map { |match| format_ambiguous_case(match) }
      },
      import_execution_plan: generate_import_plan(categorized_matches)
    }
  end

  def format_exact_match(match)
    {
      setlist_venue_name: match[:venue_name],
      setlist_location: match[:location],
      matched_venue_id: match[:matched_venue].id,
      matched_venue_name: match[:matched_venue].name,
      matched_historical_name: match[:matched_historical_name],
      confidence: match[:confidence],
      setlist_files_affected: match[:setlist_files],
      show_dates: match[:show_dates],
      import_strategy: "parallel_stage_1"
    }
  end

  def format_fuzzy_match(match)
    {
      setlist_venue_name: match[:venue_name],
      setlist_location: match[:location],
      matched_venue_id: match[:matched_venue].id,
      matched_venue_name: match[:matched_venue].name,
      matched_historical_name: match[:matched_historical_name],
      confidence: match[:confidence],
      similarity_score: match[:similarity_score],
      setlist_files_affected: match[:setlist_files],
      show_dates: match[:show_dates],
      import_strategy: "parallel_stage_2",
      manual_review_recommended: match[:confidence] < 90
    }
  end

  def format_new_venue(match)
    {
      setlist_venue_name: match[:venue_name],
      setlist_location: match[:location],
      matched_venue_id: nil,
      confidence: 0,
      reason: match[:reason],
      setlist_files_affected: match[:setlist_files],
      show_dates: match[:show_dates],
      import_strategy: "sequential_stage_3",
      venue_creation_required: true
    }
  end

  def format_ambiguous_case(match)
    {
      setlist_venue_name: match[:venue_name],
      setlist_location: match[:location],
      potential_matches: match[:potential_matches],
      confidence: 0,
      reason: "Multiple potential matches below confidence threshold",
      setlist_files_affected: match[:setlist_files],
      show_dates: match[:show_dates],
      import_strategy: "sequential_stage_4",
      claude_consultation_required: true
    }
  end

  def generate_import_plan(categorized_matches)
    exact_files = categorized_matches[:exact_matches].sum { |m| m[:setlist_files].size }
    fuzzy_files = categorized_matches[:fuzzy_matches].sum { |m| m[:setlist_files].size }
    new_files = categorized_matches[:new_venues].sum { |m| m[:setlist_files].size }
    ambiguous_files = categorized_matches[:ambiguous_cases].sum { |m| m[:setlist_files].size }

    {
      stage_1_parallel: {
        description: "Exact matches - safe for immediate parallel import",
        venue_combinations: categorized_matches[:exact_matches].size,
        file_count: exact_files,
        estimated_duration_minutes: (exact_files / 60.0).ceil
      },
      stage_2_parallel: {
        description: "Fuzzy matches - parallel with confidence validation",
        venue_combinations: categorized_matches[:fuzzy_matches].size,
        file_count: fuzzy_files,
        estimated_duration_minutes: (fuzzy_files / 45.0).ceil
      },
      stage_3_sequential: {
        description: "New venues - sequential creation to prevent race conditions",
        venue_combinations: categorized_matches[:new_venues].size,
        file_count: new_files,
        estimated_duration_minutes: (new_files / 20.0).ceil
      },
      stage_4_sequential: {
        description: "Ambiguous cases - Claude consultation required",
        venue_combinations: categorized_matches[:ambiguous_cases].size,
        file_count: ambiguous_files,
        estimated_duration_minutes: (ambiguous_files / 10.0).ceil
      }
    }
  end

  def display_analysis_summary
    puts "\n" + "=" * 60
    puts "🎯 SETLIST VENUE ANALYSIS SUMMARY"
    puts "=" * 60
    
    summary = @analysis_results[:category_summary]
    plan = @analysis_results[:import_execution_plan]
    
    puts "📊 VENUE MATCHING RESULTS:"
    puts "   ✅ Exact matches: #{summary[:exact_matches]} (#{plan[:stage_1_parallel][:file_count]} files)"
    puts "   🔍 Fuzzy matches: #{summary[:fuzzy_matches]} (#{plan[:stage_2_parallel][:file_count]} files)"
    puts "   🆕 New venues: #{summary[:new_venues]} (#{plan[:stage_3_sequential][:file_count]} files)"  
    puts "   ❓ Ambiguous cases: #{summary[:ambiguous_cases]} (#{plan[:stage_4_sequential][:file_count]} files)"
    
    total_files = plan.values.sum { |stage| stage[:file_count] }
    total_time = plan.values.sum { |stage| stage[:estimated_duration_minutes] }
    
    puts "\n📋 IMPORT EXECUTION PLAN:"
    puts "   📁 Total files to process: #{total_files}"
    puts "   ⏱️  Estimated total time: #{total_time} minutes"
    puts "   🎯 Match accuracy: #{((summary[:exact_matches] + summary[:fuzzy_matches]).to_f / (summary.values.sum) * 100).round(1)}%"
    
    puts "\n🚀 READY FOR STAGED IMPORT:"
    plan.each do |stage, details|
      puts "   #{stage}: #{details[:file_count]} files (~#{details[:estimated_duration_minutes]}min)"
    end
    
    puts "=" * 60
  end
end