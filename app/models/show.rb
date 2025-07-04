class Show < ApplicationRecord
  belongs_to :band
  belongs_to :venue
  has_many :setlist_songs, dependent: :destroy
  has_many :songs, through: :setlist_songs
  has_many :posters, dependent: :nullify

  validates :band, :venue, :show_date, :slug, presence: true
  validates :slug, uniqueness: true
  validates :show_date, uniqueness: { scope: [:band_id, :venue_id] }

  scope :by_year, ->(year) { where('EXTRACT(year FROM show_date) = ?', year) }
  scope :by_venue, ->(venue) { where(venue: venue) }
  scope :by_band, ->(band) { where(band: band) }
  scope :chronological, -> { order(:show_date) }
  scope :recent, -> { order(show_date: :desc) }

  before_validation :generate_slug, if: -> { slug.blank? }

  def display_name
    "#{band.name} at #{venue.name} - #{formatted_date}"
  end

  def formatted_date
    show_date.strftime('%B %-d, %Y')
  end

  def total_songs
    setlist_songs.count
  end

  def encore_songs
    setlist_songs.where(set_type: 'encore').count
  end

  def main_set_songs
    setlist_songs.where(set_type: 'main_set').order(:position)
  end

  def encore_set_songs
    setlist_songs.where(set_type: 'encore').order(:position)
  end

  private

  def generate_slug
    return unless band && venue && show_date
    
    base_slug = "#{band.name.parameterize}-#{venue.name.parameterize}-#{show_date.strftime('%Y-%m-%d')}"
    self.slug = base_slug
  end
end