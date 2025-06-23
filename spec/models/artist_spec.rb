require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      artist = build(:artist)
      expect(artist).to be_valid
    end

    it 'requires a name' do
      artist = build(:artist, name: nil)
      expect(artist).not_to be_valid
      expect(artist.errors[:name]).to include("can't be blank")
    end

    it 'requires unique name' do
      create(:artist, name: 'Stanley Mouse')
      artist = build(:artist, name: 'Stanley Mouse')
      expect(artist).not_to be_valid
      expect(artist.errors[:name]).to include('has already been taken')
    end

    it 'is case insensitive for uniqueness' do
      create(:artist, name: 'Stanley Mouse')
      artist = build(:artist, name: 'stanley mouse')
      expect(artist).not_to be_valid
      expect(artist.errors[:name]).to include('has already been taken')
    end

    it 'validates website format' do
      artist = build(:artist, website: 'invalid-url')
      expect(artist).not_to be_valid
      expect(artist.errors[:website]).to include('is invalid')
    end

    it 'allows valid website URLs' do
      artist = build(:artist, website: 'https://example.com')
      expect(artist).to be_valid
    end

    it 'allows blank website' do
      artist = build(:artist, website: nil)
      expect(artist).to be_valid
    end
  end

  describe 'callbacks' do
    it 'normalizes name by stripping whitespace' do
      artist = create(:artist, name: '  Stanley Mouse  ')
      expect(artist.name).to eq('Stanley Mouse')
    end
  end

  describe 'scopes' do
    let!(:artist_with_website) { create(:artist, :famous_artist) }
    let!(:artist_without_website) { create(:artist, :kelley) }

    describe '.with_website' do
      it 'returns artists with websites' do
        expect(Artist.with_website).to include(artist_with_website)
        expect(Artist.with_website).not_to include(artist_without_website)
      end
    end

    describe '.alphabetical' do
      let!(:zebra_artist) { create(:artist, name: 'Zebra Artist') }
      let!(:alpha_artist) { create(:artist, name: 'Alpha Artist') }

      it 'returns artists in alphabetical order' do
        artists = Artist.alphabetical
        expect(artists.first.name).to start_with('A')
        expect(artists.last.name).to start_with('Z')
      end
    end
  end

  describe 'search functionality' do
    let!(:stanley) { create(:artist, name: 'Stanley Mouse') }
    let!(:rick) { create(:artist, name: 'Rick Griffin') }
    let!(:alton) { create(:artist, name: 'Alton Kelley') }

    it 'searches by name' do
      results = Artist.search_by_name('Stanley')
      expect(results).to include(stanley)
      expect(results).not_to include(rick)
    end

    it 'supports partial matches' do
      results = Artist.search_by_name('Griff')
      expect(results).to include(rick)
    end

    it 'is case insensitive' do
      results = Artist.search_by_name('stanley')
      expect(results).to include(stanley)
    end
  end

  describe 'display helpers' do
    let(:artist) { create(:artist, name: 'Stanley Mouse') }

    describe '#display_name' do
      it 'returns the artist name' do
        expect(artist.display_name).to eq('Stanley Mouse')
      end
    end

    describe '#has_website?' do
      it 'returns true when website present' do
        artist.website = 'https://example.com'
        expect(artist.has_website?).to be true
      end

      it 'returns false when website blank' do
        artist.website = nil
        expect(artist.has_website?).to be false
      end
    end
  end

  describe 'class methods' do
    let!(:artist) { create(:artist, name: 'Stanley Mouse') }

    describe '.find_by_name_case_insensitive' do
      it 'finds artist by exact name' do
        found = Artist.find_by_name_case_insensitive('Stanley Mouse')
        expect(found).to eq(artist)
      end

      it 'finds artist case insensitively' do
        found = Artist.find_by_name_case_insensitive('stanley mouse')
        expect(found).to eq(artist)
      end

      it 'returns nil when not found' do
        found = Artist.find_by_name_case_insensitive('Nonexistent Artist')
        expect(found).to be_nil
      end
    end

    describe '.find_or_create_by_name' do
      it 'finds existing artist' do
        found = Artist.find_or_create_by_name('Stanley Mouse')
        expect(found).to eq(artist)
        expect(Artist.count).to eq(1)
      end

      it 'creates new artist when not found' do
        new_artist = Artist.find_or_create_by_name('New Artist')
        expect(new_artist).to be_persisted
        expect(new_artist.name).to eq('New Artist')
        expect(Artist.count).to eq(2)
      end

      it 'is case insensitive for finding' do
        found = Artist.find_or_create_by_name('stanley mouse')
        expect(found).to eq(artist)
        expect(Artist.count).to eq(1)
      end
    end
  end
end