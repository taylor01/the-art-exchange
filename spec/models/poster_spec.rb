require 'rails_helper'

RSpec.describe Poster, type: :model do
  let(:band) { create(:band) }
  let(:venue) { create(:venue) }
  let(:artist) { create(:artist) }
  let(:series) { create(:series) }

  describe 'associations' do
    it 'belongs to band' do
      poster = build(:poster, band: band, venue: venue)
      expect(poster.band).to eq(band)
    end

    it 'belongs to venue' do
      poster = build(:poster, band: band, venue: venue)
      expect(poster.venue).to eq(venue)
    end

    it 'has and belongs to many artists' do
      poster = create(:poster, band: band, venue: venue)
      poster.artists << artist
      expect(poster.artists).to include(artist)
    end

    it 'has and belongs to many series' do
      poster = create(:poster, band: band, venue: venue)
      poster.series << series
      expect(poster.series).to include(series)
    end
  end

  describe 'validations' do
    it 'validates presence of name' do
      poster = build(:poster, name: nil, band: band, venue: venue)
      expect(poster).not_to be_valid
      expect(poster.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of release_date' do
      poster = build(:poster, release_date: nil, band: band, venue: venue)
      expect(poster).not_to be_valid
      expect(poster.errors[:release_date]).to include("can't be blank")
    end

    it 'validates numericality of original_price when present' do
      poster = build(:poster, original_price: -1, band: band, venue: venue)
      expect(poster).not_to be_valid
      expect(poster.errors[:original_price]).to include("must be greater than 0")
    end

    it 'allows nil original_price' do
      poster = build(:poster, original_price: nil, band: band, venue: venue)
      expect(poster).to be_valid
    end

    it 'allows blank original_price' do
      poster = build(:poster, original_price: '', band: band, venue: venue)
      expect(poster).to be_valid
    end

    it 'validates edition_size is positive integer when present' do
      poster = build(:poster, edition_size: -50, band: band, venue: venue)
      expect(poster).not_to be_valid
      expect(poster.errors[:edition_size]).to include("must be greater than 0")
    end

    it 'validates edition_size is an integer when present' do
      poster = build(:poster, edition_size: 50.5, band: band, venue: venue)
      expect(poster).not_to be_valid
      expect(poster.errors[:edition_size]).to include("must be an integer")
    end

    it 'allows blank edition_size' do
      poster = build(:poster, edition_size: nil, band: band, venue: venue)
      expect(poster).to be_valid
    end

    it 'allows valid edition_size' do
      poster = build(:poster, edition_size: 500, band: band, venue: venue)
      expect(poster).to be_valid
    end
  end

  describe 'callbacks' do
    it 'normalizes name before validation' do
      poster = build(:poster, name: '  Test Poster  ', band: band, venue: venue)
      poster.valid?
      expect(poster.name).to eq('Test Poster')
    end
  end

  describe 'display helpers' do
    it 'returns formatted display name' do
      poster = create(:poster, name: 'Concert Poster', band: band, venue: venue)
      expected = "#{poster.name} - #{poster.band.name} at #{poster.venue.name}"
      expect(poster.display_name).to eq(expected)
    end

    it 'returns formatted price' do
      poster = create(:poster, band: band, venue: venue)
      poster.original_price_in_dollars = 25.50
      poster.save!
      expect(poster.formatted_price).to eq('$25.50')
    end

    it 'returns price unknown for missing price' do
      poster = create(:poster, original_price: nil, band: band, venue: venue)
      expect(poster.formatted_price).to eq('Price Unknown')
    end
  end

  describe 'era helpers' do
    it 'identifies vintage posters' do
      poster = create(:poster, :vintage, band: band, venue: venue)
      expect(poster.vintage?).to be true
    end

    it 'identifies golden age posters' do
      poster = create(:poster, :golden_age, band: band, venue: venue)
      expect(poster.golden_age?).to be true
    end
  end

  describe 'artist helpers' do
    it 'handles collaborative posters' do
      poster = create(:poster, band: band, venue: venue)
      poster.artists << [ artist, create(:artist) ]
      expect(poster.collaborative?).to be true
      expect(poster.solo_artist?).to be false
    end

    it 'handles solo artist posters' do
      poster = create(:poster, band: band, venue: venue)
      poster.artists << artist
      expect(poster.solo_artist?).to be true
      expect(poster.collaborative?).to be false
    end
  end

  describe 'series helpers' do
    it 'identifies posters in series' do
      poster = create(:poster, band: band, venue: venue)
      poster.series << series
      expect(poster.in_series?).to be true
    end

    it 'identifies posters not in series' do
      poster = create(:poster, band: band, venue: venue)
      expect(poster.in_series?).to be false
    end
  end

  describe 'search functionality' do
    it 'includes PgSearch::Model' do
      expect(Poster.included_modules).to include(PgSearch::Model)
    end

    it 'defines search scope' do
      expect(Poster).to respond_to(:search_by_name_and_description)
    end
  end

  describe 'visual metadata' do
    let(:sample_metadata) do
      {
        'visual' => {
          'art_style' => 'minimalist',
          'color_palette' => [ 'black', 'white', 'blue' ]
        },
        'thematic' => {
          'primary_themes' => [ 'celestial', 'night_sky' ],
          'mood' => [ 'peaceful', 'dreamy' ],
          'elements' => [ 'moon', 'stars' ]
        },
        'market_appeal' => {
          'display_context' => [ 'bedroom', 'office' ],
          'wall_color_match' => [ 'white', 'gray' ]
        }
      }
    end

    let(:poster_with_metadata) do
      create(:poster, band: band, venue: venue, visual_metadata: sample_metadata)
    end

    describe '#has_metadata?' do
      it 'returns true when metadata is present' do
        expect(poster_with_metadata.has_metadata?).to be true
      end

      it 'returns false when metadata is nil' do
        poster = create(:poster, band: band, venue: venue, visual_metadata: nil)
        expect(poster.has_metadata?).to be false
      end
    end

    describe 'metadata version methods' do
      describe '#metadata_version_current?' do
        it 'returns true when version matches current' do
          poster = create(:poster, metadata_version: PosterMetadataService::CURRENT_METADATA_VERSION)
          expect(poster.metadata_version_current?).to be true
        end

        it 'returns false when version is outdated' do
          poster = create(:poster, metadata_version: '0.9')
          expect(poster.metadata_version_current?).to be false
        end

        it 'returns false when version is nil' do
          poster = create(:poster, metadata_version: nil)
          expect(poster.metadata_version_current?).to be false
        end
      end

      describe '#metadata_version_outdated?' do
        it 'returns true when has metadata but version is outdated' do
          poster = create(:poster, visual_metadata: { 'test' => 'data' }, metadata_version: '0.9')
          expect(poster.metadata_version_outdated?).to be true
        end

        it 'returns false when version is current' do
          poster = create(:poster, visual_metadata: { 'test' => 'data' }, metadata_version: PosterMetadataService::CURRENT_METADATA_VERSION)
          expect(poster.metadata_version_outdated?).to be false
        end

        it 'returns false when no metadata' do
          poster = create(:poster, visual_metadata: nil, metadata_version: '0.9')
          expect(poster.metadata_version_outdated?).to be false
        end
      end

      describe '#metadata_version_missing?' do
        it 'returns true when has metadata but no version' do
          poster = create(:poster, visual_metadata: { 'test' => 'data' }, metadata_version: nil)
          expect(poster.metadata_version_missing?).to be true
        end

        it 'returns false when has version' do
          poster = create(:poster, visual_metadata: { 'test' => 'data' }, metadata_version: '1.0')
          expect(poster.metadata_version_missing?).to be false
        end

        it 'returns false when no metadata' do
          poster = create(:poster, visual_metadata: nil, metadata_version: nil)
          expect(poster.metadata_version_missing?).to be false
        end
      end

      describe '#needs_reanalysis?' do
        it 'returns true when no metadata' do
          poster = create(:poster, visual_metadata: nil)
          expect(poster.needs_reanalysis?).to be true
        end

        it 'returns true when metadata but outdated version' do
          poster = create(:poster, visual_metadata: { 'test' => 'data' }, metadata_version: '0.9')
          expect(poster.needs_reanalysis?).to be true
        end

        it 'returns true when metadata but missing version' do
          poster = create(:poster, visual_metadata: { 'test' => 'data' }, metadata_version: nil)
          expect(poster.needs_reanalysis?).to be true
        end

        it 'returns false when current version' do
          poster = create(:poster, visual_metadata: { 'test' => 'data' }, metadata_version: PosterMetadataService::CURRENT_METADATA_VERSION)
          expect(poster.needs_reanalysis?).to be false
        end
      end
    end

    describe '#metadata_art_style' do
      it 'returns the art style from metadata' do
        expect(poster_with_metadata.metadata_art_style).to eq('minimalist')
      end

      it 'returns nil when metadata is missing' do
        poster = create(:poster, band: band, venue: venue)
        expect(poster.metadata_art_style).to be_nil
      end
    end

    describe '#metadata_color_palette' do
      it 'returns the color palette array' do
        expect(poster_with_metadata.metadata_color_palette).to eq([ 'black', 'white', 'blue' ])
      end
    end

    describe '#metadata_mood' do
      it 'returns the mood array' do
        expect(poster_with_metadata.metadata_mood).to eq([ 'peaceful', 'dreamy' ])
      end
    end

    describe '#metadata_themes' do
      it 'returns the themes array' do
        expect(poster_with_metadata.metadata_themes).to eq([ 'celestial', 'night_sky' ])
      end
    end

    describe '#metadata_elements' do
      it 'returns the elements array' do
        expect(poster_with_metadata.metadata_elements).to eq([ 'moon', 'stars' ])
      end
    end

    describe '#metadata_display_context' do
      it 'returns the display context array' do
        expect(poster_with_metadata.metadata_display_context).to eq([ 'bedroom', 'office' ])
      end
    end

    describe '#metadata_wall_colors' do
      it 'returns the wall color match array' do
        expect(poster_with_metadata.metadata_wall_colors).to eq([ 'white', 'gray' ])
      end
    end
  end
end
