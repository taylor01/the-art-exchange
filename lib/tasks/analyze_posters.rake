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

  desc "Show analysis statistics"
  task stats: :environment do
    total_posters = Poster.count
    posters_with_images = Poster.joins(:image_attachment).count
    posters_with_metadata = Poster.where.not(visual_metadata: nil).count

    puts "📊 Poster Analysis Statistics:"
    puts "   Total posters: #{total_posters}"
    puts "   Posters with images: #{posters_with_images}"
    puts "   Posters with metadata: #{posters_with_metadata}"
    puts "   Analysis coverage: #{posters_with_images > 0 ? (posters_with_metadata * 100.0 / posters_with_images).round(1) : 0}%"

    if posters_with_metadata > 0
      puts "\n🎨 Most common art styles:"
      style_counts = Poster.where.not(visual_metadata: nil)
                          .group("visual_metadata->'visual'->>'art_style'")
                          .count
                          .sort_by { |k, v| -v }
                          .first(5)

      style_counts.each do |style, count|
        puts "   #{style}: #{count}"
      end
    end
  end
end
