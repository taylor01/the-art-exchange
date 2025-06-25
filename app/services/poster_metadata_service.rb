# frozen_string_literal: true

class PosterMetadataService
  class << self
    def analyze_poster(poster)
      return unless poster.image.attached?

      begin
        metadata = extract_visual_metadata(poster.image)
        poster.update!(visual_metadata: metadata)
        metadata
      rescue => e
        Rails.logger.error "Failed to analyze poster #{poster.id}: #{e.message}"
        nil
      end
    end

    def analyze_all_posters
      posters_with_images = Poster.joins(:image_attachment)
      total_count = posters_with_images.count
      analyzed_count = 0
      failed_count = 0

      puts "🔍 Analyzing #{total_count} posters with images..."

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

    private

    def extract_visual_metadata(image)
      # For now, we'll return a sample structure
      # TODO: Replace with actual Claude API call
      {
        "visual" => {
          "color_palette" => [ "black", "white", "blue" ],
          "dominant_colors" => [ "#000000", "#ffffff", "#4a90e2" ],
          "art_style" => "minimalist",
          "composition" => "centered_focal_point",
          "complexity" => "simple",
          "text_density" => "minimal"
        },
        "thematic" => {
          "primary_themes" => [ "celestial", "night_sky" ],
          "mood" => [ "peaceful", "dreamy" ],
          "elements" => [ "moon", "clouds", "stars" ],
          "genre" => "nature_abstract"
        },
        "technical" => {
          "layout" => "portrait",
          "typography_style" => "modern_sans_serif",
          "design_era" => "contemporary",
          "print_quality_indicators" => [ "clean_lines", "high_contrast" ]
        },
        "collectibility" => {
          "visual_rarity" => "common_style",
          "artistic_significance" => "medium",
          "design_complexity" => "low",
          "iconic_elements" => [ "distinctive_design" ]
        },
        "market_appeal" => {
          "demographic_appeal" => [ "millennials", "music_fans" ],
          "display_context" => [ "bedroom", "office" ],
          "frame_compatibility" => "high",
          "wall_color_match" => [ "white", "gray", "dark_walls" ]
        }
      }
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
            "wall_color_match": ["color1", "color2"]
          }
        }

        Use only lowercase, snake_case values where applicable. No additional text or explanation.
      PROMPT
    end

    # TODO: Implement actual Claude API integration
    def call_claude_api(image_data)
      # This would make the actual API call to Claude
      # For now, return sample data
      extract_visual_metadata(nil)
    end
  end
end
