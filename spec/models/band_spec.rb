require 'rails_helper'

RSpec.describe Band, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      band = build(:band)
      expect(band).to be_valid
    end

    it 'requires a name' do
      band = build(:band, name: nil)
      expect(band).not_to be_valid
      expect(band.errors[:name]).to include("can't be blank")
    end

    it 'requires unique name' do
      create(:band, name: 'Grateful Dead')
      band = build(:band, name: 'Grateful Dead')
      expect(band).not_to be_valid
      expect(band.errors[:name]).to include('has already been taken')
    end

    it 'is case insensitive for uniqueness' do
      create(:band, name: 'Grateful Dead')
      band = build(:band, name: 'grateful dead')
      expect(band).not_to be_valid
      expect(band.errors[:name]).to include('has already been taken')
    end

    it 'validates website format' do
      band = build(:band, website: 'invalid-url')
      expect(band).not_to be_valid
      expect(band.errors[:website]).to include('is invalid')
    end

    it 'allows valid website URLs' do
      band = build(:band, website: 'https://example.com')
      expect(band).to be_valid
    end

    it 'allows blank website' do
      band = build(:band, website: nil)
      expect(band).to be_valid
    end
  end

  describe 'callbacks' do
    it 'normalizes name by stripping whitespace' do
      band = create(:band, name: '  Grateful Dead  ')
      expect(band.name).to eq('Grateful Dead')
    end
  end

  describe 'scopes' do
    let!(:band_with_website) { create(:band, :grateful_dead) }
    let!(:band_without_website) { create(:band, :jimi_hendrix) }

    describe '.with_website' do
      it 'returns bands with websites' do
        expect(Band.with_website).to include(band_with_website)
        expect(Band.with_website).not_to include(band_without_website)
      end
    end

    describe '.alphabetical' do
      let!(:zebra_band) { create(:band, name: 'Zebra Band') }
      let!(:alpha_band) { create(:band, name: 'Alpha Band') }

      it 'returns bands in alphabetical order' do
        bands = Band.alphabetical
        expect(bands.first.name).to start_with('A')
        expect(bands.last.name).to start_with('Z')
      end
    end
  end

  describe 'search functionality' do
    let!(:grateful_dead) { create(:band, name: 'Grateful Dead') }
    let!(:dave_matthews) { create(:band, name: 'Dave Matthews Band') }
    let!(:pink_floyd) { create(:band, name: 'Pink Floyd') }

    it 'searches by name' do
      results = Band.search_by_name('Grateful')
      expect(results).to include(grateful_dead)
      expect(results).not_to include(dave_matthews)
    end

    it 'supports partial matches' do
      results = Band.search_by_name('Matthews')
      expect(results).to include(dave_matthews)
    end

    it 'is case insensitive' do
      results = Band.search_by_name('grateful')
      expect(results).to include(grateful_dead)
    end
  end

  describe 'display helpers' do
    let(:band) { create(:band, name: 'Grateful Dead') }

    describe '#display_name' do
      it 'returns the band name' do
        expect(band.display_name).to eq('Grateful Dead')
      end
    end

    describe '#has_website?' do
      it 'returns true when website present' do
        band.website = 'https://example.com'
        expect(band.has_website?).to be true
      end

      it 'returns false when website blank' do
        band.website = nil
        expect(band.has_website?).to be false
      end
    end
  end

  describe 'class methods' do
    let!(:band) { create(:band, name: 'Grateful Dead') }

    describe '.find_by_name_case_insensitive' do
      it 'finds band by exact name' do
        found = Band.find_by_name_case_insensitive('Grateful Dead')
        expect(found).to eq(band)
      end

      it 'finds band case insensitively' do
        found = Band.find_by_name_case_insensitive('grateful dead')
        expect(found).to eq(band)
      end

      it 'returns nil when not found' do
        found = Band.find_by_name_case_insensitive('Nonexistent Band')
        expect(found).to be_nil
      end
    end

    describe '.find_or_create_by_name' do
      it 'finds existing band' do
        found = Band.find_or_create_by_name('Grateful Dead')
        expect(found).to eq(band)
        expect(Band.count).to eq(1)
      end

      it 'creates new band when not found' do
        new_band = Band.find_or_create_by_name('New Band')
        expect(new_band).to be_persisted
        expect(new_band.name).to eq('New Band')
        expect(Band.count).to eq(2)
      end

      it 'is case insensitive for finding' do
        found = Band.find_or_create_by_name('grateful dead')
        expect(found).to eq(band)
        expect(Band.count).to eq(1)
      end
    end
  end
end