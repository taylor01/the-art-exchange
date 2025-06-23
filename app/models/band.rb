class Band < ApplicationRecord
  # Include search functionality
  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: [ :name ],
    using: {
      tsearch: { prefix: true }
    }

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true

  # Callbacks
  before_validation :normalize_name

  # Scopes
  scope :with_website, -> { where.not(website: [ nil, "" ]) }
  scope :alphabetical, -> { order(:name) }

  # Display helpers
  def display_name
    name
  end

  def has_website?
    website.present?
  end

  # Search helpers
  def self.find_by_name_case_insensitive(search_name)
    where("LOWER(name) = ?", search_name.downcase).first
  end

  def self.find_or_create_by_name(band_name)
    find_by_name_case_insensitive(band_name) || create!(name: band_name)
  end

  private

  def normalize_name
    self.name = name&.strip
  end
end
