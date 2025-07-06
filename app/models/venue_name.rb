class VenueName < ApplicationRecord
  belongs_to :venue
  
  validates :name, presence: true
  validates :venue_id, presence: true
  
  scope :current, -> { where(current: true) }
  scope :historical, -> { where(current: false) }
  scope :active_on, ->(date) { where('start_date <= ? AND (end_date IS NULL OR end_date >= ?)', date, date) }
  
  # Include search functionality for venue names
  include PgSearch::Model
  pg_search_scope :search,
    against: [:name],
    using: {
      tsearch: { prefix: true },
      trigram: { threshold: 0.3 }
    }
  
  def date_range
    if start_date && end_date
      "#{start_date.year} - #{end_date.year}"
    elsif start_date
      "#{start_date.year} - present"
    else
      "Unknown"
    end
  end
  
  def active_on?(date)
    return false unless start_date
    return false if start_date > date
    return false if end_date && end_date < date
    true
  end
end