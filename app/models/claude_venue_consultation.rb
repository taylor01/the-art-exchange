class ClaudeVenueConsultation < ApplicationRecord
  belongs_to :venue
  
  validates :original_venue_name, presence: true
  validates :location, presence: true
  validates :show_date, presence: true
  
  scope :successful_matches, -> { where(match_found: true) }
  scope :failed_matches, -> { where(match_found: false) }
  scope :high_confidence, -> { where('confidence >= ?', 80) }
  scope :low_confidence, -> { where('confidence < ?', 50) }
  
  def consultation_summary
    status = match_found? ? "✅ MATCH" : "❌ NO MATCH"
    conf = confidence ? "(#{confidence}%)" : "(no confidence)"
    "#{status} #{conf}: '#{original_venue_name}' in #{location}"
  end
  
  def success?
    match_found == true
  end
  
  def high_confidence?
    confidence && confidence >= 80
  end
end