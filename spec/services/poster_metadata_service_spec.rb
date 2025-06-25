# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PosterMetadataService do
  let(:poster) { create(:poster, :with_image) }
  let(:mock_anthropic_client) { instance_double(Anthropic::Client) }
  let(:mock_metadata) do
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

  let(:mock_api_response) do
    {
      "content" => [
        {
          "text" => mock_metadata.to_json
        }
      ]
    }
  end

  before do
    # Mock the private extract_visual_metadata method to return test data
    allow(PosterMetadataService).to receive(:extract_visual_metadata).and_return(mock_metadata)
  end

  describe '.analyze_poster' do
    context 'when poster has an image' do
      it 'extracts and stores visual metadata with current version' do
        expect {
          PosterMetadataService.analyze_poster(poster)
        }.to change { poster.reload.visual_metadata }.from(nil).to(be_present)
         .and change { poster.reload.metadata_version }.from(nil).to(PosterMetadataService::CURRENT_METADATA_VERSION)
      end

      it 'returns the extracted metadata' do
        metadata = PosterMetadataService.analyze_poster(poster)

        expect(metadata).to be_a(Hash)
        expect(metadata).to have_key('visual')
        expect(metadata).to have_key('thematic')
        expect(metadata).to have_key('technical')
        expect(metadata).to have_key('collectibility')
        expect(metadata).to have_key('market_appeal')
      end

      it 'populates expected visual metadata fields' do
        metadata = PosterMetadataService.analyze_poster(poster)

        visual = metadata['visual']
        expect(visual['color_palette']).to be_an(Array)
        expect(visual['art_style']).to be_a(String)
        expect(visual['composition']).to be_a(String)
      end

      it 'populates expected thematic metadata fields' do
        metadata = PosterMetadataService.analyze_poster(poster)

        thematic = metadata['thematic']
        expect(thematic['primary_themes']).to be_an(Array)
        expect(thematic['mood']).to be_an(Array)
        expect(thematic['elements']).to be_an(Array)
      end
    end

    context 'when poster has no image' do
      let(:poster_without_image) { create(:poster) }

      it 'returns nil' do
        result = PosterMetadataService.analyze_poster(poster_without_image)
        expect(result).to be_nil
      end

      it 'does not modify the poster' do
        expect {
          PosterMetadataService.analyze_poster(poster_without_image)
        }.not_to change { poster_without_image.reload.visual_metadata }
      end
    end
  end

  describe '.analyze_all_posters' do
    let!(:poster_with_image) { create(:poster, :with_image) }
    let!(:poster_without_image) { create(:poster) }

    it 'enqueues background jobs for all posters with images' do
      expect {
        PosterMetadataService.analyze_all_posters
      }.to have_enqueued_job(PosterMetadataAnalysisJob).with(poster_with_image)
    end

    it 'does not enqueue jobs for posters without images' do
      expect {
        PosterMetadataService.analyze_all_posters
      }.not_to have_enqueued_job(PosterMetadataAnalysisJob).with(poster_without_image)
    end
  end

  describe '.analyze_all_posters_sync' do
    let!(:poster_with_image) { create(:poster, :with_image) }
    let!(:poster_without_image) { create(:poster) }

    it 'analyzes all posters that have images synchronously' do
      expect {
        PosterMetadataService.analyze_all_posters_sync
      }.to change { poster_with_image.reload.visual_metadata }.from(nil).to(be_present)
    end

    it 'skips posters without images' do
      expect {
        PosterMetadataService.analyze_all_posters_sync
      }.not_to change { poster_without_image.reload.visual_metadata }
    end
  end

  describe '.analyze_poster_async' do
    it 'enqueues a background job for the poster' do
      expect {
        PosterMetadataService.analyze_poster_async(poster)
      }.to have_enqueued_job(PosterMetadataAnalysisJob).with(poster)
    end
  end

  describe '.analyze_outdated_posters' do
    let!(:current_poster) { create(:poster, :with_image, metadata_version: PosterMetadataService::CURRENT_METADATA_VERSION) }
    let!(:outdated_poster) { create(:poster, :with_image, metadata_version: "0.9") }
    let!(:unversioned_poster) { create(:poster, :with_image, metadata_version: nil) }

    it 'enqueues jobs for outdated posters' do
      expect {
        PosterMetadataService.analyze_outdated_posters
      }.to have_enqueued_job(PosterMetadataAnalysisJob).with(outdated_poster)
       .and have_enqueued_job(PosterMetadataAnalysisJob).with(unversioned_poster)
    end

    it 'does not enqueue jobs for current version posters' do
      expect {
        PosterMetadataService.analyze_outdated_posters
      }.not_to have_enqueued_job(PosterMetadataAnalysisJob).with(current_poster)
    end
  end

  describe '.metadata_stats' do
    it 'outputs statistics without errors' do
      expect {
        PosterMetadataService.metadata_stats
      }.to output(/📊 Metadata Statistics/).to_stdout
    end
  end
end
