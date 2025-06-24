class Poster < ApplicationRecord
  # Associations
  belongs_to :band
  belongs_to :venue
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :series
  has_many :user_posters, dependent: :destroy
  has_many :users, through: :user_posters

  # Image attachment - one official image per poster/variant
  has_one_attached :image

  # Include search functionality
  include PgSearch::Model
  pg_search_scope :search_by_name_and_description,
    against: [ :name, :description ],
    associated_against: {
      band: [ :name ],
      venue: [ :name, :city ],
      artists: [ :name ],
      series: [ :name ]
    },
    using: {
      tsearch: { prefix: true }
    }

  # Validations
  validates :name, presence: true
  validates :release_date, presence: true
  validates :original_price, numericality: { greater_than: 0 }, allow_blank: true

  # Callbacks
  before_validation :normalize_name

  # Scopes
  scope :by_year, ->(year) { where("EXTRACT(year FROM release_date) = ?", year) }
  scope :by_decade, ->(decade) { where("EXTRACT(year FROM release_date) BETWEEN ? AND ?", decade, decade + 9) }
  scope :recent, -> { where("release_date >= ?", 5.years.ago) }
  scope :vintage, -> { where("release_date < ?", 30.years.ago) }
  scope :golden_age, -> { where("release_date BETWEEN ? AND ?", Date.new(1965), Date.new(1975)) }
  scope :with_price, -> { where.not(original_price: nil) }
  scope :chronological, -> { order(:release_date, :name) }
  scope :alphabetical, -> { order(:name) }
  scope :by_band, ->(band) { where(band: band) }
  scope :by_venue, ->(venue) { where(venue: venue) }
  scope :by_artist, ->(artist) { joins(:artists).where(artists: { id: artist.id }) }
  scope :in_series, ->(series) { joins(:series).where(series: { id: series.id }) }

  # Display helpers
  def display_name
    "#{name} - #{band.name} at #{venue.name}"
  end

  def full_title
    parts = [ name, band.name, venue.name ]
    parts << release_date.strftime("%Y") if release_date
    parts.compact.join(" • ")
  end

  def event_summary
    return "#{band.name} at #{venue.name}" unless release_date
    "#{band.name} at #{venue.name} (#{release_date.strftime('%B %d, %Y')})"
  end

  def short_title
    parts = [ name ]
    parts << release_date.year.to_s if release_date
    parts.join(" ")
  end

  # Date helpers
  def year
    release_date&.year
  end

  def decade
    return nil unless year
    "#{(year / 10) * 10}s"
  end

  def formatted_date
    return "Date Unknown" unless release_date
    release_date.strftime("%B %d, %Y")
  end

  # Era helpers
  def vintage?
    release_date && release_date < 30.years.ago
  end

  def modern?
    release_date && release_date >= 10.years.ago
  end

  def golden_age?
    release_date && release_date.between?(Date.new(1965), Date.new(1975))
  end

  # Price helpers
  def has_price?
    original_price.present?
  end

  def formatted_price
    return "Price Unknown" unless original_price
    "$#{original_price}"
  end

  # Artist helpers
  def artist_names
    artists.pluck(:name).join(", ")
  end

  def primary_artist
    artists.first
  end

  def collaborative?
    artists.count > 1
  end

  def solo_artist?
    artists.count == 1
  end

  # Series helpers
  def series_names
    series.pluck(:name).join(", ")
  end

  def in_series?
    series.any?
  end

  def series_count
    series.count
  end

  # Location helpers
  def venue_location
    venue&.location_summary
  end

  def venue_city
    venue&.city
  end

  # Search helpers
  def self.search_all_fields(query)
    search_by_name_and_description(query)
  end

  def self.find_by_event(band_name, venue_name, date = nil)
    scope = joins(:band, :venue)
            .where("bands.name ILIKE ? AND venues.name ILIKE ?", "%#{band_name}%", "%#{venue_name}%")
    scope = scope.where(release_date: date) if date
    scope
  end

  private

  def normalize_name
    self.name = name&.strip
  end
end
