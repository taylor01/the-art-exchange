class SetlistSong < ApplicationRecord
  belongs_to :show
  belongs_to :song

  validates :show, :song, :set_type, :position, presence: true
  validates :position, uniqueness: { scope: [:show_id, :set_type] }
  validates :set_type, inclusion: { in: %w[main_set encore] }
  validates :position, numericality: { greater_than: 0 }

  scope :main_set, -> { where(set_type: 'main_set') }
  scope :encore, -> { where(set_type: 'encore') }
  scope :with_guests, -> { where("notes @> ?", [{ type: 'guest_musician' }].to_json) }
  scope :with_notes, -> { where.not(notes: nil) }
  scope :ordered, -> { order(:set_type, :position) }

  def has_guests?
    return false unless notes.present?
    
    notes.any? { |note| note['type'] == 'guest_musician' }
  end

  def guest_musicians
    return [] unless has_guests?
    
    notes.select { |note| note['type'] == 'guest_musician' }
         .map { |note| "#{note['name']} (#{note['instrument']})" }
  end

  def has_segue?
    return false unless notes.present?
    
    notes.any? { |note| note['type'] == 'segue' }
  end

  def segue_info
    return nil unless has_segue?
    
    segue_note = notes.find { |note| note['type'] == 'segue' }
    segue_note&.dig('into') || segue_note&.dig('note')
  end

  def has_jam?
    return false unless notes.present?
    
    notes.any? { |note| note['type'] == 'jam' }
  end

  def jam_info
    return nil unless has_jam?
    
    jam_note = notes.find { |note| note['type'] == 'jam' }
    jam_note&.dig('description') || 'Extended jam'
  end

  def has_tease?
    return false unless notes.present?
    
    notes.any? { |note| note['type'] == 'tease' }
  end

  def tease_info
    return nil unless has_tease?
    
    tease_note = notes.find { |note| note['type'] == 'tease' }
    "#{tease_note&.dig('song')} tease"
  end

  def special_performance?
    has_guests? || has_jam? || has_tease? || has_segue?
  end

  def display_position
    "#{set_type == 'main_set' ? 'Set' : 'Encore'} #{position}"
  end

  def notes_summary
    return nil unless notes.present?
    
    summaries = []
    summaries << guest_musicians.join(', ') if has_guests?
    summaries << "Segue into #{segue_info}" if has_segue?
    summaries << jam_info if has_jam?
    summaries << tease_info if has_tease?
    
    summaries.join(' • ')
  end

  def is_encore?
    set_type == 'encore'
  end

  def is_main_set?
    set_type == 'main_set'
  end
end