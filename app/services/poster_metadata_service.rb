# frozen_string_literal: true

class PosterMetadataService
  # Current metadata version - increment when changing the schema
  CURRENT_METADATA_VERSION = "1.0"

  class << self
    def analyze_poster(poster)
      return unless poster.image.attached?

      begin
        metadata = extract_visual_metadata(poster.image)
        poster.update!(
          visual_metadata: metadata,
          metadata_version: CURRENT_METADATA_VERSION
        )
        metadata
      rescue => e
        Rails.logger.error "Failed to analyze poster #{poster.id}: #{e.message}"
        nil
      end
    end

    def analyze_poster_async(poster)
      PosterMetadataAnalysisJob.perform_later(poster)
    end

    def analyze_all_posters
      posters_with_images = Poster.joins(:image_attachment)
      total_count = posters_with_images.count

      puts "🔍 Enqueueing #{total_count} posters for background analysis..."

      posters_with_images.find_each.with_index do |poster, index|
        print "📈 Enqueueing poster #{index + 1}/#{total_count} (#{((index + 1) * 100.0 / total_count).round(1)}%): #{poster.name}\r"
        analyze_poster_async(poster)
      end

      puts "\n✅ All posters enqueued for background analysis"
    end

    def analyze_all_posters_sync
      posters_with_images = Poster.joins(:image_attachment)
      total_count = posters_with_images.count
      analyzed_count = 0
      failed_count = 0

      puts "🔍 Analyzing #{total_count} posters with images synchronously..."

      posters_with_images.find_each.with_index do |poster, index|
        print "📈 Processing poster #{index + 1}/#{total_count} (#{((index + 1) * 100.0 / total_count).round(1)}%): #{poster.name}\r"

        if analyze_poster(poster)
          analyzed_count += 1
        else
          failed_count += 1
        end
      end

      puts "\n✅ Analysis complete: #{analyzed_count} analyzed, #{failed_count} failed"
    end

    def analyze_outdated_posters
      outdated_posters = Poster.joins(:image_attachment)
                               .where.not(metadata_version: CURRENT_METADATA_VERSION)
                               .or(Poster.joins(:image_attachment).where(metadata_version: nil))

      total_count = outdated_posters.count
      puts "🔄 Found #{total_count} posters with outdated or missing metadata versions..."

      outdated_posters.find_each.with_index do |poster, index|
        print "📈 Re-analyzing poster #{index + 1}/#{total_count} (#{((index + 1) * 100.0 / total_count).round(1)}%): #{poster.name}\r"
        analyze_poster_async(poster)
      end

      puts "\n✅ All outdated posters enqueued for re-analysis"
    end

    def metadata_stats
      total_posters = Poster.joins(:image_attachment).count
      analyzed_posters = Poster.where.not(visual_metadata: nil).count
      current_version_posters = Poster.where(metadata_version: CURRENT_METADATA_VERSION).count

      puts "📊 Metadata Statistics:"
      puts "   Total posters with images: #{total_posters}"
      puts "   Analyzed posters: #{analyzed_posters}"
      puts "   Current version (#{CURRENT_METADATA_VERSION}): #{current_version_posters}"
      puts "   Outdated/missing version: #{analyzed_posters - current_version_posters}"
    end

    private

    def extract_visual_metadata(image)
      # Resize and encode image for API call
      optimized_image_data = resize_and_encode_image(image)

      # Call Claude API with optimized image
      call_claude_api(optimized_image_data)
    rescue StandardError => e
      Rails.logger.error "Failed to extract visual metadata: #{e.message}"
      # Return nil to trigger background job retry
      nil
    end

    def resize_and_encode_image(image)
      # Resize image to max 1500px on longest side to optimize for API calls
      # while maintaining quality for visual analysis
      begin
        resized_image = image.variant(resize_to_limit: [ 1500, 1500 ]).processed
        blob_data = resized_image.blob.download
      rescue LoadError => e
        # Handle missing libvips in test/development environments
        Rails.logger.warn "Image processing library not available: #{e.message}"
        Rails.logger.warn "Using original image size for API call"
        blob_data = image.blob.download
      end

      # Encode as base64
      Base64.strict_encode64(blob_data)
    end

    def claude_analysis_prompt
      <<~PROMPT
        You are a poster metadata analyst. Analyze the provided poster image and return ONLY a valid JSON object with the following exact structure:

        {
          "visual": {
            "color_palette": ["color1", "color2", "color3"],
            "dominant_colors": ["#hex1", "#hex2", "#hex3"],
            "art_style": "style_category",
            "composition": "composition_type",
            "complexity": "simple|moderate|complex",
            "text_density": "minimal|moderate|heavy"
          },
          "thematic": {
            "primary_themes": ["theme1", "theme2"],
            "mood": ["mood1", "mood2"],
            "elements": ["element1", "element2"],
            "genre": "genre_category"
          },
          "technical": {
            "layout": "portrait|landscape|square",
            "typography_style": "style_description",
            "design_era": "era_category",
            "print_quality_indicators": ["indicator1", "indicator2"]
          },
          "collectibility": {
            "visual_rarity": "common_style|uncommon_style|rare_style",
            "artistic_significance": "low|medium|high",
            "design_complexity": "low|medium|high",
            "iconic_elements": ["element1", "element2"]
          },
          "market_appeal": {
            "demographic_appeal": ["demographic1", "demographic2"],
            "display_context": ["context1", "context2"],
            "frame_compatibility": "low|medium|high",
            "wall_color_match": ["color1", "color2"],
            "wall_color_complementary": ["color1", "color2", "color3"]
          }
        }

        Use only lowercase, snake_case values where applicable. No additional text or explanation.
      PROMPT
    end

    def call_claude_api(image_data)
      client = Anthropic::Client.new(api_key: ENV["ANTHROPIC_API_KEY"])

      response = client.messages.create(
        model: "claude-3-haiku-20240307",
        max_tokens: 1500,
        messages: [
          {
            role: "user",
            content: [
              {
                type: "image",
                source: {
                  type: "base64",
                  media_type: "image/jpeg",
                  data: image_data
                }
              },
              {
                type: "text",
                text: claude_analysis_prompt
              }
            ]
          }
        ]
      )

      # Parse the JSON response
      response_text = response.content.first.text
      JSON.parse(response_text)
    rescue JSON::ParserError => e
      Rails.logger.error "Failed to parse Claude API response: #{e.message}"
      Rails.logger.error "Response text: #{response_text}"
      nil
    rescue StandardError => e
      Rails.logger.error "Claude API call failed: #{e.message}"
      nil
    end
  end
end
