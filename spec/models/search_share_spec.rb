require 'rails_helper'

RSpec.describe SearchShare, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:search_params) }

    describe 'token validation' do
      it 'has validation rules for token presence' do
        share = SearchShare.new(search_params: '{"q": "test"}')
        # Skip the callback to test the validation directly
        share.define_singleton_method(:generate_token) { }
        share.valid?
        expect(share.errors[:token]).to include("can't be blank")
      end

      it 'has validation rules for token uniqueness' do
        existing_share = create(:search_share)
        new_share = SearchShare.new(search_params: '{"q": "test"}', token: existing_share.token)
        # Skip the callback to test the validation directly
        new_share.define_singleton_method(:generate_token) { }
        expect(new_share).not_to be_valid
        expect(new_share.errors[:token]).to include("has already been taken")
      end
    end
  end

  describe 'callbacks' do
    it 'generates a token before validation on create' do
      search_share = SearchShare.new(search_params: '{"q": "test"}')
      expect(search_share.token).to be_nil
      search_share.valid?
      expect(search_share.token).to be_present
      expect(search_share.token.length).to eq(8)
    end

    it 'generates unique tokens' do
      # Create first share
      first_share = create(:search_share)

      # Mock SecureRandom to return the same token initially, then a different one
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return(first_share.token, 'unique12')

      second_share = SearchShare.new(search_params: '{"q": "test2"}')
      second_share.valid?

      expect(second_share.token).to eq('unique12')
      expect(second_share.token).not_to eq(first_share.token)
    end
  end

  describe 'scopes' do
    describe '.active' do
      let!(:active_share) { create(:search_share, expires_at: 1.day.from_now) }
      let!(:expired_share) { create(:search_share, expires_at: 1.day.ago) }

      it 'returns only non-expired shares' do
        expect(SearchShare.active).to include(active_share)
        expect(SearchShare.active).not_to include(expired_share)
      end
    end
  end

  describe '.create_for_search' do
    let(:search_params) { { q: 'beatles', artists: [ 'Beatles' ], page: '2', per_page: '20', blank_param: '' } }

    it 'creates a search share record' do
      expect {
        SearchShare.create_for_search(search_params)
      }.to change(SearchShare, :count).by(1)
    end

    it 'removes pagination and blank parameters' do
      share = SearchShare.create_for_search(search_params)
      parsed = share.parsed_params

      expect(parsed).to have_key('q')
      expect(parsed).to have_key('artists')
      expect(parsed).not_to have_key('page')
      expect(parsed).not_to have_key('per_page')
      expect(parsed).not_to have_key('blank_param')
    end

    it 'sets expiration to 1 year from creation' do
      travel_to Time.current do
        share = SearchShare.create_for_search(search_params)
        expect(share.expires_at).to be_within(1.second).of(1.year.from_now)
      end
    end

    it 'stores search params as JSON' do
      share = SearchShare.create_for_search(search_params)
      expect(share.search_params).to be_a(String)

      parsed = JSON.parse(share.search_params)
      expect(parsed['q']).to eq('beatles')
      expect(parsed['artists']).to eq([ 'Beatles' ])
    end
  end

  describe '#expired?' do
    it 'returns true when expires_at is in the past' do
      share = build(:search_share, expires_at: 1.day.ago)
      expect(share).to be_expired
    end

    it 'returns false when expires_at is in the future' do
      share = build(:search_share, expires_at: 1.day.from_now)
      expect(share).not_to be_expired
    end

    it 'returns true when expires_at is exactly now' do
      travel_to Time.current do
        share = build(:search_share, expires_at: Time.current)
        expect(share).to be_expired
      end
    end
  end

  describe '#parsed_params' do
    it 'returns parsed JSON as indifferent access hash' do
      params = { q: 'test', artists: [ 'Beatles' ] }
      share = create(:search_share, search_params: params.to_json)

      parsed = share.parsed_params
      expect(parsed[:q]).to eq('test')
      expect(parsed['q']).to eq('test')
      expect(parsed[:artists]).to eq([ 'Beatles' ])
    end

    it 'returns empty hash for invalid JSON' do
      share = build(:search_share, search_params: 'invalid json')
      expect(share.parsed_params).to eq({})
    end

    it 'returns empty hash for nil search_params' do
      share = build(:search_share)
      share.search_params = nil
      expect(share.parsed_params).to eq({})
    end
  end
end
