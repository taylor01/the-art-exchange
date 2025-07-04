class AlbumSong < ApplicationRecord
  belongs_to :album
  belongs_to :song

  validates :album, :song, presence: true
  validates :song_id, uniqueness: { scope: :album_id }
  validates :track_number, uniqueness: { scope: [:album_id, :disc_number] }, allow_nil: true
  validates :track_number, numericality: { greater_than: 0 }, allow_nil: true
  validates :disc_number, numericality: { greater_than: 0 }

  scope :by_track_order, -> { order(:disc_number, :track_number) }
  scope :for_disc, ->(disc) { where(disc_number: disc) }

  def display_track_number
    if track_number.present?
      disc_number > 1 ? "#{disc_number}-#{track_number}" : track_number.to_s
    else
      "—"
    end
  end

  def has_track_number?
    track_number.present?
  end

  def is_multi_disc?
    disc_number > 1
  end

  def position_description
    parts = []
    parts << "Disc #{disc_number}" if is_multi_disc?
    parts << "Track #{track_number}" if has_track_number?
    parts.join(", ")
  end
end