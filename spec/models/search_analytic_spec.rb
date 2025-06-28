require 'rails_helper'

RSpec.describe SearchAnalytic, type: :model do
  describe 'associations' do
    it { should belong_to(:user).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:performed_at) }
  end

  describe 'scopes' do
    let!(:recent_search) { create(:search_analytic, performed_at: 15.days.ago) }
    let!(:old_search) { create(:search_analytic, performed_at: 45.days.ago) }
    let!(:query_search) { create(:search_analytic, query: 'test query') }
    let!(:empty_query_search) { create(:search_analytic, query: '') }
    let!(:faceted_search) { create(:search_analytic, facet_filters: { artists: ['Beatles'] }) }
    let!(:non_faceted_search) { create(:search_analytic, facet_filters: nil) }

    describe '.recent' do
      it 'returns searches from the last 30 days' do
        expect(SearchAnalytic.recent).to include(recent_search)
        expect(SearchAnalytic.recent).not_to include(old_search)
      end
    end

    describe '.with_query' do
      it 'returns searches with non-empty queries' do
        expect(SearchAnalytic.with_query).to include(query_search)
        expect(SearchAnalytic.with_query).not_to include(empty_query_search)
      end
    end

    describe '.with_facets' do
      it 'returns searches with facet filters' do
        expect(SearchAnalytic.with_facets).to include(faceted_search)
        expect(SearchAnalytic.with_facets).not_to include(non_faceted_search)
      end
    end
  end

  describe '.track_search' do
    let(:user) { create(:user) }
    let(:params) { { q: 'test query', artists: ['Beatles'], venues: ['Madison Square Garden'] } }

    it 'creates a search analytic record' do
      expect {
        SearchAnalytic.track_search(params, user: user, results_count: 5)
      }.to change(SearchAnalytic, :count).by(1)
    end

    it 'records the query' do
      analytic = SearchAnalytic.track_search(params, user: user, results_count: 5)
      expect(analytic.query).to eq('test query')
    end

    it 'records facet filters' do
      analytic = SearchAnalytic.track_search(params, user: user, results_count: 5)
      expect(analytic.facet_filters).to eq({
        'artists' => ['Beatles'],
        'venues' => ['Madison Square Garden']
      })
    end

    it 'records results count' do
      analytic = SearchAnalytic.track_search(params, user: user, results_count: 5)
      expect(analytic.results_count).to eq(5)
    end

    it 'records the user' do
      analytic = SearchAnalytic.track_search(params, user: user, results_count: 5)
      expect(analytic.user).to eq(user)
    end

    it 'allows anonymous tracking' do
      analytic = SearchAnalytic.track_search(params, results_count: 5)
      expect(analytic.user).to be_nil
    end

    it 'strips whitespace from query' do
      params_with_spaces = { q: '  test query  ' }
      analytic = SearchAnalytic.track_search(params_with_spaces)
      expect(analytic.query).to eq('test query')
    end

    it 'handles empty queries' do
      params_empty = { q: '' }
      analytic = SearchAnalytic.track_search(params_empty)
      expect(analytic.query).to be_nil
    end
  end

  describe '.popular_queries' do
    before do
      create(:search_analytic, query: 'beatles', performed_at: 1.day.ago)
      create(:search_analytic, query: 'beatles', performed_at: 2.days.ago)
      create(:search_analytic, query: 'stones', performed_at: 1.day.ago)
      create(:search_analytic, query: 'old query', performed_at: 45.days.ago)
    end

    it 'returns popular queries from recent searches' do
      popular = SearchAnalytic.popular_queries
      expect(popular['beatles']).to eq(2)
      expect(popular['stones']).to eq(1)
      expect(popular).not_to have_key('old query')
    end

    it 'respects the limit parameter' do
      popular = SearchAnalytic.popular_queries(limit: 1)
      expect(popular.size).to eq(1)
      expect(popular.keys.first).to eq('beatles')
    end
  end

  describe '.popular_facets' do
    before do
      create(:search_analytic, 
        facet_filters: { artists: ['Beatles'], venues: ['Abbey Road'] }, 
        performed_at: 1.day.ago
      )
      create(:search_analytic, 
        facet_filters: { artists: ['Stones'], venues: ['Abbey Road'] }, 
        performed_at: 2.days.ago
      )
      create(:search_analytic, 
        facet_filters: { artists: ['Old Band'] }, 
        performed_at: 45.days.ago
      )
    end

    it 'returns popular facet keys from recent searches' do
      popular = SearchAnalytic.popular_facets
      expect(popular).to include(['artists', 2])
      expect(popular).to include(['venues', 2])
    end

    it 'excludes old searches' do
      popular = SearchAnalytic.popular_facets
      facet_counts = popular.to_h
      expect(facet_counts['artists']).to eq(2) # Only recent searches
    end

    it 'respects the limit parameter' do
      popular = SearchAnalytic.popular_facets(limit: 1)
      expect(popular.size).to eq(1)
    end
  end
end
