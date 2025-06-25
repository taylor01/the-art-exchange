# frozen_string_literal: true

namespace :posters do
  desc "Analyze all posters with images to extract visual metadata"
  task analyze_all: :environment do
    puts "🎨 Starting poster visual metadata analysis..."
    PosterMetadataService.analyze_all_posters
    puts "🎯 Poster analysis complete!"
  end

  desc "Analyze a specific poster by ID"
  task :analyze, [ :poster_id ] => :environment do |task, args|
    poster_id = args[:poster_id]

    unless poster_id
      puts "❌ Please provide a poster ID: rake posters:analyze[123]"
      exit 1
    end

    poster = Poster.find_by(id: poster_id)
    unless poster
      puts "❌ Poster with ID #{poster_id} not found"
      exit 1
    end

    unless poster.image.attached?
      puts "❌ Poster #{poster_id} (#{poster.name}) has no image attached"
      exit 1
    end

    puts "🔍 Analyzing poster #{poster_id}: #{poster.name}"

    metadata = PosterMetadataService.analyze_poster(poster)
    if metadata
      puts "✅ Analysis complete!"
      puts "📊 Metadata preview:"
      puts "   Art style: #{metadata.dig('visual', 'art_style')}"
      puts "   Themes: #{metadata.dig('thematic', 'primary_themes')&.join(', ')}"
      puts "   Mood: #{metadata.dig('thematic', 'mood')&.join(', ')}"
      puts "   Color palette: #{metadata.dig('visual', 'color_palette')&.join(', ')}"
    else
      puts "❌ Analysis failed"
      exit 1
    end
  end

  desc "Show metadata for a poster"
  task :show_metadata, [ :poster_id ] => :environment do |task, args|
    poster_id = args[:poster_id]

    unless poster_id
      puts "❌ Please provide a poster ID: rake posters:show_metadata[123]"
      exit 1
    end

    poster = Poster.find_by(id: poster_id)
    unless poster
      puts "❌ Poster with ID #{poster_id} not found"
      exit 1
    end

    puts "📋 Metadata for poster #{poster_id}: #{poster.name}"

    if poster.visual_metadata.present?
      puts JSON.pretty_generate(poster.visual_metadata)
    else
      puts "❌ No metadata found. Run analysis first: rake posters:analyze[#{poster_id}]"
    end
  end

  desc "Show analysis statistics including version information"
  task stats: :environment do
    PosterMetadataService.metadata_stats
  end

  desc "Analyze posters with outdated metadata versions"
  task analyze_outdated: :environment do
    puts "🔄 Starting analysis of posters with outdated metadata versions..."
    PosterMetadataService.analyze_outdated_posters
    puts "🎯 Outdated poster analysis complete!"
  end

  desc "Re-analyze specific poster to update to current metadata version"
  task :reanalyze, [ :poster_id ] => :environment do |task, args|
    poster_id = args[:poster_id]

    unless poster_id
      puts "❌ Please provide a poster ID: rake posters:reanalyze[123]"
      exit 1
    end

    poster = Poster.find_by(id: poster_id)
    unless poster
      puts "❌ Poster with ID #{poster_id} not found"
      exit 1
    end

    unless poster.image.attached?
      puts "❌ Poster #{poster_id} (#{poster.name}) has no image attached"
      exit 1
    end

    current_version = poster.metadata_version
    puts "🔄 Re-analyzing poster #{poster_id}: #{poster.name}"
    puts "   Current version: #{current_version || 'none'}"
    puts "   Target version: #{PosterMetadataService::CURRENT_METADATA_VERSION}"

    metadata = PosterMetadataService.analyze_poster(poster)
    if metadata
      puts "✅ Re-analysis complete!"
      puts "   Updated to version: #{poster.reload.metadata_version}"
      puts "📊 Metadata preview:"
      puts "   Art style: #{metadata.dig('visual', 'art_style')}"
      puts "   Themes: #{metadata.dig('thematic', 'primary_themes')&.join(', ')}"
      puts "   Mood: #{metadata.dig('thematic', 'mood')&.join(', ')}"
      puts "   Color palette: #{metadata.dig('visual', 'color_palette')&.join(', ')}"
    else
      puts "❌ Re-analysis failed"
      exit 1
    end
  end
end
