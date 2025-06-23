require 'rails_helper'

RSpec.describe Venue, type: :model do
  describe 'basic functionality' do
    it 'can create a venue with minimal attributes' do
      venue = Venue.new(name: 'Test Venue')
      expect(venue.name).to eq('Test Venue')
      expect(venue.venue_type).to eq('other')
      expect(venue.status).to eq('active')
    end

    it 'validates required name' do
      venue = Venue.new
      expect(venue).not_to be_valid
      expect(venue.errors[:name]).to include("can't be blank")
    end

    it 'is valid with just a name' do
      venue = Venue.new(name: 'Test Venue')
      expect(venue).to be_valid
    end
  end

  describe 'enums' do
    it 'has venue_type enum' do
      venue = Venue.new(name: 'Test')
      venue.venue_type = 'theater'
      expect(venue.venue_type).to eq('theater')
    end

    it 'has status enum' do
      venue = Venue.new(name: 'Test')
      venue.status = 'closed'
      expect(venue.status).to eq('closed')
    end
  end

  describe 'factory' do
    before do
      # Mock geocoding to avoid API calls
      allow_any_instance_of(Venue).to receive(:geocode)
    end

    it 'can build a venue' do
      venue = build(:venue)
      expect(venue.name).to be_present
      expect(venue).to be_valid
    end

    it 'can create a venue' do
      venue = create(:venue)
      expect(venue).to be_persisted
      expect(venue.name).to eq('Test Theater')
    end
  end

  describe 'basic methods' do
    before do
      allow_any_instance_of(Venue).to receive(:geocode)
    end

    let(:venue) { create(:venue) }

    it 'has display_name method' do
      expect(venue.display_name).to eq(venue.name)
    end

    it 'has full_address method' do
      expect(venue.full_address).to include(venue.city)
    end

    it 'has geocoded? method' do
      expect(venue.geocoded?).to be true
    end
  end
end
