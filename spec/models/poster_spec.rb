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

    it 'validates presence of slug' do
      poster = build(:poster, band: band, venue: venue)
      poster.slug = nil
      poster.define_singleton_method(:generate_slug) { } # Skip slug generation
      expect(poster).not_to be_valid
      expect(poster.errors[:slug]).to include("can't be blank")
    end

    it 'validates uniqueness of slug' do
      existing_poster = create(:poster, band: band, venue: venue)
      duplicate_poster = build(:poster, slug: existing_poster.slug, band: band, venue: venue)
      expect(duplicate_poster).not_to be_valid
      expect(duplicate_poster.errors[:slug]).to include("has already been taken")
    end
  end

  describe 'callbacks' do
    it 'normalizes name before validation' do
      poster = build(:poster, name: '  Test Poster  ', band: band, venue: venue)
      poster.valid?
      expect(poster.name).to eq('Test Poster')
    end

    it 'generates slug before validation' do
      poster = build(:poster, name: 'Test Poster', band: band, venue: venue, release_date: Date.new(2023, 6, 15))
      poster.valid?
      expect(poster.slug).to be_present
      expect(poster.slug).to include(band.name.parameterize)
      expect(poster.slug).to include(venue.name.parameterize)
      expect(poster.slug).to include('test-poster')
      expect(poster.slug).to include('2023')
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

  describe 'slug functionality' do
    describe '#to_param' do
      it 'returns slug when present' do
        poster = create(:poster, band: band, venue: venue)
        expect(poster.to_param).to eq(poster.slug)
      end

      it 'returns ID when slug is blank' do
        poster = create(:poster, band: band, venue: venue)
        poster.update_column(:slug, nil)
        expect(poster.to_param).to eq(poster.id.to_s)
      end
    end

    describe '.find_by_slug_or_id' do
      let!(:poster) { create(:poster, band: band, venue: venue) }

      it 'finds poster by slug' do
        found_poster = Poster.find_by_slug_or_id(poster.slug)
        expect(found_poster).to eq(poster)
      end

      it 'finds poster by ID when slug lookup fails' do
        found_poster = Poster.find_by_slug_or_id(poster.id.to_s)
        expect(found_poster).to eq(poster)
      end

      it 'raises error when neither slug nor ID exists' do
        expect { Poster.find_by_slug_or_id('nonexistent') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'slug generation' do
      it 'generates slug with band, venue, name, and year' do
        poster = create(:poster, 
          name: 'Test Poster', 
          band: band, 
          venue: venue, 
          release_date: Date.new(2023, 6, 15)
        )
        expected_parts = [band.name.parameterize, venue.name.parameterize, 'test-poster', '2023']
        expect(poster.slug).to eq(expected_parts.join('-'))
      end

      it 'generates slug without band when not present' do
        poster = create(:poster, 
          name: 'Test Poster', 
          band: nil, 
          venue: venue, 
          release_date: Date.new(2023, 6, 15)
        )
        expected_parts = [venue.name.parameterize, 'test-poster', '2023']
        expect(poster.slug).to eq(expected_parts.join('-'))
      end

      it 'generates slug without venue when not present' do
        poster = create(:poster, 
          name: 'Test Poster', 
          band: band, 
          venue: nil, 
          release_date: Date.new(2023, 6, 15)
        )
        expected_parts = [band.name.parameterize, 'test-poster', '2023']
        expect(poster.slug).to eq(expected_parts.join('-'))
      end

      it 'generates slug with proper components including year' do
        poster = create(:poster, 
          name: 'Test Poster', 
          band: band, 
          venue: venue, 
          release_date: Date.new(2023, 6, 15)
        )
        # Test that slug includes year and main components
        expect(poster.slug).to include('2023')
        expect(poster.slug).to include('test-poster')
        # Test that slug includes band and venue components (may have IDs appended)
        expect(poster.slug).to include(band.name.parameterize.split('_').first)
        expect(poster.slug).to include(venue.name.parameterize.split('_').first)
      end

      it 'handles special characters in names' do
        special_band = create(:band, name: 'The B@nd!')
        special_venue = create(:venue, name: 'Venue & Place')
        poster = create(:poster, 
          name: 'Special Poster', 
          band: special_band, 
          venue: special_venue, 
          release_date: Date.new(2023, 6, 15)
        )
        # Test that parameterize handles special characters appropriately
        expect(poster.slug).to include('the-b-nd')
        expect(poster.slug).to include('venue-place')
        expect(poster.slug).to include('special-poster')
        expect(poster.slug).to include('2023')
      end
    end

    describe 'unique slug generation' do
      it 'adds numeric suffix for duplicate slugs' do
        first_poster = create(:poster, name: 'Test Poster', band: band, venue: venue, release_date: Date.new(2023, 6, 15))
        second_poster = create(:poster, name: 'Test Poster', band: band, venue: venue, release_date: Date.new(2023, 6, 15))
        
        expect(first_poster.slug).not_to include('-1')
        expect(second_poster.slug).to eq("#{first_poster.slug}-1")
      end

      it 'continues incrementing for multiple duplicates' do
        base_slug = nil
        3.times do |i|
          poster = create(:poster, name: 'Test Poster', band: band, venue: venue, release_date: Date.new(2023, 6, 15))
          if i == 0
            base_slug = poster.slug
            expect(poster.slug).not_to include('-1')
          else
            expect(poster.slug).to eq("#{base_slug}-#{i}")
          end
        end
      end
    end

    describe 'slug regeneration' do
      let!(:poster) { create(:poster, name: 'Original Name', band: band, venue: venue, release_date: Date.new(2023, 6, 15)) }

      it 'slug contains expected components' do
        expect(poster.slug).to include(band.name.parameterize)
        expect(poster.slug).to include(venue.name.parameterize)
        expect(poster.slug).to include('original-name')
        expect(poster.slug).to include('2023')
      end

      it 'regenerates slug when name changes' do
        original_slug = poster.slug
        poster.update!(name: 'New Name')
        poster.reload
        expect(poster.slug).not_to eq(original_slug)
        expect(poster.slug).to include('new-name')
        expect(poster.slug).not_to include('original-name')
      end

      it 'regenerates slug when band changes' do
        original_slug = poster.slug
        new_band = create(:band, name: 'New Band')
        poster.update!(band: new_band)
        poster.reload
        expect(poster.slug).not_to eq(original_slug)
        expect(poster.slug).to include('new-band')
      end

      it 'regenerates slug when venue changes' do
        original_slug = poster.slug
        new_venue = create(:venue, name: 'New Venue')
        poster.update!(venue: new_venue)
        poster.reload
        expect(poster.slug).not_to eq(original_slug)
        expect(poster.slug).to include('new-venue')
      end

      it 'regenerates slug when release date year changes' do
        original_slug = poster.slug
        poster.update!(release_date: Date.new(2024, 6, 15))
        poster.reload
        expect(poster.slug).not_to eq(original_slug)
        expect(poster.slug).to include('2024')
        expect(poster.slug).not_to include('2023')
      end

      it 'does not regenerate slug for non-slug-affecting changes' do
        original_slug = poster.slug
        poster.update!(description: 'New description')
        poster.reload
        expect(poster.slug).to eq(original_slug)
      end
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
