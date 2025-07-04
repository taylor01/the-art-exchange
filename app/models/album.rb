class Album < ApplicationRecord
  belongs_to :band
  has_many :album_songs, dependent: :destroy
  has_many :songs, through: :album_songs

  validates :title, :album_type, presence: true
  validates :title, uniqueness: { scope: :band_id }
  validates :album_type, inclusion: { in: %w[studio live compilation single] }

  scope :studio_albums, -> { where(album_type: 'studio') }
  scope :live_albums, -> { where(album_type: 'live') }
  scope :by_release_date, -> { order(:release_date) }
  scope :by_band, ->(band) { where(band: band) }

  def track_count
    album_songs.count
  end

  def release_year
    release_date&.year
  end

  def album_type_display
    album_type.titleize
  end

  def display_title
    if release_year
      "#{title} (#{release_year})"
    else
      title
    end
  end

  def is_studio_album?
    album_type == 'studio'
  end

  def is_live_album?
    album_type == 'live'
  end

  def tracklist
    album_songs.includes(:song).order(:disc_number, :track_number)
  end

  def disc_count
    album_songs.maximum(:disc_number) || 1
  end

  def tracks_for_disc(disc_number)
    album_songs.includes(:song)
              .where(disc_number: disc_number)
              .order(:track_number)
  end

  def has_musicbrainz_data?
    musicbrainz_id.present?
  end

  def has_spotify_data?
    spotify_id.present?
  end
end