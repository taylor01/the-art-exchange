class Song < ApplicationRecord
  include PgSearch::Model
  
  has_many :setlist_songs, dependent: :destroy
  has_many :shows, through: :setlist_songs
  has_many :album_songs, dependent: :destroy
  has_many :albums, through: :album_songs

  validates :title, :slug, presence: true
  validates :title, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: true

  scope :covers, -> { where(is_cover_song: true) }
  scope :originals, -> { where(is_cover_song: false) }
  scope :frequently_played, -> { joins(:setlist_songs).group('songs.id').having('COUNT(setlist_songs.id) >= ?', 10) }
  scope :rarely_played, -> { joins(:setlist_songs).group('songs.id').having('COUNT(setlist_songs.id) <= ?', 5) }
  scope :by_first_performance, -> { order(:first_performed_at) }

  pg_search_scope :search_by_title_and_artist,
    against: [:title, :artist_credit],
    using: {
      tsearch: { prefix: true },
      trigram: { threshold: 0.3 }
    }

  before_validation :generate_slug, if: -> { slug.blank? }

  def is_cover?
    is_cover_song
  end

  def performance_count
    setlist_songs.count
  end

  def last_performed_at
    shows.maximum(:show_date)
  end

  def debut_show
    shows.order(:show_date).first
  end

  def display_title
    if artist_credit.present?
      "#{title} (#{artist_credit})"
    else
      title
    end
  end

  def cover_info
    return nil unless is_cover?
    
    if original_artist.present?
      "Cover of #{original_artist}"
    else
      "Cover song"
    end
  end

  def audio_energy
    audio_features&.dig('energy')
  end

  def audio_tempo
    audio_features&.dig('tempo')
  end

  def audio_danceability
    audio_features&.dig('danceability')
  end

  def has_audio_features?
    audio_features.present?
  end

  private

  def generate_slug
    return unless title.present?
    
    base_slug = title.parameterize
    counter = 1
    slug_candidate = base_slug
    
    while Song.exists?(slug: slug_candidate)
      slug_candidate = "#{base_slug}-#{counter}"
      counter += 1
    end
    
    self.slug = slug_candidate
  end
end