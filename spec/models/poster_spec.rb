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
      poster = create(:poster, original_price: 25.50, band: band, venue: venue)
      expect(poster.formatted_price).to eq('$25.5')
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
end
