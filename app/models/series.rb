class Series < ApplicationRecord
  # Associations
  has_and_belongs_to_many :posters

  # Include search functionality
  include PgSearch::Model
  pg_search_scope :search_by_name_and_description,
    against: [ :name, :description ],
    using: {
      tsearch: { prefix: true }
    }

  # Validations
  validates :name, presence: true
  validates :year, presence: true,
            numericality: {
              greater_than: 1950,
              less_than_or_equal_to: -> { Date.current.year + 1 }
            }
  validates :total_count, numericality: { greater_than: 0 }, allow_blank: true

  # Callbacks
  before_validation :normalize_name

  # Scopes
  scope :by_year, ->(year) { where(year: year) }
  scope :recent, -> { where("year >= ?", 10.years.ago.year) }
  scope :classic, -> { where("year < ?", 20.years.ago.year) }
  scope :with_total_count, -> { where.not(total_count: nil) }
  scope :alphabetical, -> { order(:name) }
  scope :chronological, -> { order(:year, :name) }

  # Display helpers
  def display_name
    year.present? ? "#{name} (#{year})" : name
  end

  def full_title
    parts = [ name ]
    parts << year.to_s if year.present?
    parts.join(" - ")
  end

  def has_total_count?
    total_count.present?
  end

  def decade
    return nil unless year.present?
    "#{(year / 10) * 10}s"
  end

  # Era helpers
  def vintage?
    year.present? && year < 1980
  end

  def modern?
    year.present? && year >= 2000
  end

  def golden_age?
    year.present? && year.between?(1965, 1975)
  end

  private

  def normalize_name
    self.name = name&.strip
  end
end
