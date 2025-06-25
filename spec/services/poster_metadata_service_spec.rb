# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PosterMetadataService do
  let(:poster) { create(:poster, :with_image) }

  describe '.analyze_poster' do
    context 'when poster has an image' do
      it 'extracts and stores visual metadata' do
        expect {
          PosterMetadataService.analyze_poster(poster)
        }.to change { poster.reload.visual_metadata }.from(nil).to(be_present)
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

    it 'analyzes all posters that have images' do
      expect {
        PosterMetadataService.analyze_all_posters
      }.to change { poster_with_image.reload.visual_metadata }.from(nil).to(be_present)
    end

    it 'skips posters without images' do
      expect {
        PosterMetadataService.analyze_all_posters
      }.not_to change { poster_without_image.reload.visual_metadata }
    end
  end
end
