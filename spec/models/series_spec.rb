require 'rails_helper'

RSpec.describe Series, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      series = build(:series)
      expect(series).to be_valid
    end

    it 'requires a name' do
      series = build(:series, name: nil)
      expect(series).not_to be_valid
      expect(series.errors[:name]).to include("can't be blank")
    end

    it 'requires a year' do
      series = build(:series, year: nil)
      expect(series).not_to be_valid
      expect(series.errors[:year]).to include("can't be blank")
    end

    it 'validates year is after 1950' do
      series = build(:series, year: 1949)
      expect(series).not_to be_valid
      expect(series.errors[:year]).to include('must be greater than 1950')
    end

    it 'validates year is not too far in the future' do
      series = build(:series, year: Date.current.year + 2)
      expect(series).not_to be_valid
      expect(series.errors[:year]).to include("must be less than or equal to #{Date.current.year + 1}")
    end

    it 'allows current year' do
      series = build(:series, year: Date.current.year)
      expect(series).to be_valid
    end

    it 'validates total_count is positive when present' do
      series = build(:series, total_count: -1)
      expect(series).not_to be_valid
      expect(series.errors[:total_count]).to include('must be greater than 0')
    end

    it 'allows nil total_count' do
      series = build(:series, total_count: nil)
      expect(series).to be_valid
    end
  end

  describe 'callbacks' do
    it 'normalizes name by stripping whitespace' do
      series = create(:series, name: '  Playing Card Series  ')
      expect(series.name).to eq('Playing Card Series')
    end
  end

  describe 'scopes' do
    let!(:vintage_series) { create(:series, :vintage_series) }
    let!(:modern_series) { create(:series, :modern_series) }
    let!(:fillmore_series) { create(:series, :fillmore_west) }
    let!(:series_without_count) { create(:series, :without_total_count) }

    describe '.by_year' do
      it 'returns series from specific year' do
        expect(Series.by_year(1969)).to include(vintage_series)
        expect(Series.by_year(1969)).not_to include(modern_series)
      end
    end

    describe '.recent' do
      it 'returns series from last 10 years' do
        expect(Series.recent).to include(modern_series)
        expect(Series.recent).not_to include(vintage_series)
      end
    end

    describe '.classic' do
      it 'returns series older than 20 years' do
        expect(Series.classic).to include(vintage_series, fillmore_series)
        expect(Series.classic).not_to include(modern_series)
      end
    end

    describe '.with_total_count' do
      it 'returns series that have total_count set' do
        expect(Series.with_total_count).to include(vintage_series)
        expect(Series.with_total_count).not_to include(series_without_count)
      end
    end

    describe '.alphabetical' do
      it 'returns series in alphabetical order by name' do
        series = Series.alphabetical
        names = series.map(&:name)
        expect(names).to eq(names.sort)
      end
    end

    describe '.chronological' do
      it 'returns series ordered by year then name' do
        series = Series.chronological
        years = series.map(&:year)
        expect(years.first).to be <= years.last
      end
    end
  end

  describe 'search functionality' do
    let!(:playing_cards) { create(:series, :playing_cards) }
    let!(:grateful_dead) { create(:series, :grateful_dead_europe) }
    let!(:fillmore) { create(:series, :fillmore_west) }

    it 'searches by name' do
      results = Series.search_by_name_and_description('Playing Card')
      expect(results).to include(playing_cards)
      expect(results).not_to include(grateful_dead)
    end

    it 'searches by description' do
      results = Series.search_by_name_and_description('European tour')
      expect(results).to include(grateful_dead)
      expect(results).not_to include(playing_cards)
    end

    it 'supports partial matches' do
      results = Series.search_by_name_and_description('Fillmore')
      expect(results).to include(fillmore)
    end

    it 'is case insensitive' do
      results = Series.search_by_name_and_description('playing card')
      expect(results).to include(playing_cards)
    end
  end

  describe 'display helpers' do
    let(:series) { create(:series, name: 'Test Series', year: 1969) }

    describe '#display_name' do
      it 'includes year when present' do
        expect(series.display_name).to eq('Test Series (1969)')
      end

      it 'excludes year when not present' do
        series.year = nil
        expect(series.display_name).to eq('Test Series')
      end
    end

    describe '#full_title' do
      it 'joins name and year with dash' do
        expect(series.full_title).to eq('Test Series - 1969')
      end

      it 'returns just name when no year' do
        series.year = nil
        expect(series.full_title).to eq('Test Series')
      end
    end

    describe '#has_total_count?' do
      it 'returns true when total_count present' do
        series.total_count = 5
        expect(series.has_total_count?).to be true
      end

      it 'returns false when total_count nil' do
        series.total_count = nil
        expect(series.has_total_count?).to be false
      end
    end

    describe '#decade' do
      it 'returns decade string' do
        series.year = 1969
        expect(series.decade).to eq('1960s')
      end

      it 'handles different decades' do
        series.year = 2003
        expect(series.decade).to eq('2000s')
      end

      it 'returns nil when no year' do
        series.year = nil
        expect(series.decade).to be_nil
      end
    end
  end

  describe 'era helpers' do
    describe '#vintage?' do
      it 'returns true for pre-1980 series' do
        series = build(:series, year: 1975)
        expect(series.vintage?).to be true
      end

      it 'returns false for 1980+ series' do
        series = build(:series, year: 1985)
        expect(series.vintage?).to be false
      end
    end

    describe '#modern?' do
      it 'returns true for 2000+ series' do
        series = build(:series, year: 2010)
        expect(series.modern?).to be true
      end

      it 'returns false for pre-2000 series' do
        series = build(:series, year: 1990)
        expect(series.modern?).to be false
      end
    end

    describe '#golden_age?' do
      it 'returns true for 1965-1975 series' do
        series = build(:series, year: 1970)
        expect(series.golden_age?).to be true
      end

      it 'returns false for outside golden age' do
        series = build(:series, year: 1980)
        expect(series.golden_age?).to be false
      end

      it 'includes boundary years' do
        expect(build(:series, year: 1965).golden_age?).to be true
        expect(build(:series, year: 1975).golden_age?).to be true
      end
    end
  end

  describe 'factory traits' do
    it 'creates playing cards series correctly' do
      series = create(:series, :playing_cards)
      expect(series.name).to eq('Playing Card Series')
      expect(series.year).to eq(2003)
      expect(series.total_count).to eq(5)
    end

    it 'creates vintage series correctly' do
      series = create(:series, :vintage_series)
      expect(series.vintage?).to be true
      expect(series.golden_age?).to be true
    end

    it 'creates modern series correctly' do
      series = create(:series, :modern_series)
      expect(series.modern?).to be true
      expect(series.vintage?).to be false
    end
  end
end
