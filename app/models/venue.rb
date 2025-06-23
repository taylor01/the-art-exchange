class Venue < ApplicationRecord
  # Include geocoding functionality
  geocoded_by :full_address
  after_validation :geocode, if: :location_fields_changed?

  # Include search functionality
  include PgSearch::Model
  pg_search_scope :search_by_name_and_location,
    against: [ :name, :city, :administrative_area, :country ],
    using: {
      tsearch: { prefix: true }
    }

  # Enums
  enum :venue_type, {
    theater: "theater",
    concert_hall: "concert_hall",
    club: "club",
    arena: "arena",
    stadium: "stadium",
    outdoor: "outdoor",
    gallery: "gallery",
    museum: "museum",
    festival_grounds: "festival_grounds",
    other: "other"
  }

  enum :status, {
    active: "active",
    closed: "closed",
    relocated: "relocated",
    temporarily_closed: "temporarily_closed"
  }

  # Validations
  validates :name, presence: true
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :capacity, numericality: { greater_than: 0, allow_blank: true }
  validates :latitude, inclusion: { in: -90..90 }, allow_blank: true
  validates :longitude, inclusion: { in: -180..180 }, allow_blank: true

  # Callbacks
  before_save :ensure_previous_names_array

  # Scopes
  scope :active, -> { where(status: "active") }
  scope :in_country, ->(country) { where(country: country) }
  scope :by_venue_type, ->(type) { where(venue_type: type) }
  scope :with_coordinates, -> { where.not(latitude: nil, longitude: nil) }

  # Name history management
  def add_previous_name(old_name)
    return if old_name.blank? || old_name == name

    self.previous_names ||= []
    unless previous_names.include?(old_name)
      self.previous_names << old_name
      save! if persisted?
    end
  end

  def all_names
    ([ name ] + (previous_names || [])).uniq
  end

  def has_been_known_as?(search_name)
    all_names.any? { |n| n.downcase.include?(search_name.downcase) }
  end

  # Duplicate detection
  def self.find_nearby_venues(address_string, radius_in_meters = 100)
    coordinates = Geocoder.coordinates(address_string)
    return none unless coordinates

    latitude, longitude = coordinates
    within_radius_of(latitude, longitude, radius_in_meters)
  end

  def self.within_radius_of(lat, lng, radius_in_meters)
    # Convert meters to approximate degrees (rough approximation)
    radius_in_degrees = radius_in_meters / 111_000.0

    where(
      "latitude BETWEEN ? AND ? AND longitude BETWEEN ? AND ?",
      lat - radius_in_degrees, lat + radius_in_degrees,
      lng - radius_in_degrees, lng + radius_in_degrees
    ).with_coordinates
  end

  def nearby_venues(radius_in_meters = 100)
    return self.class.none unless geocoded?

    self.class.within_radius_of(latitude, longitude, radius_in_meters)
           .where.not(id: id)
  end

  def potential_duplicates
    nearby_venues(100)
  end

  # Address and location helpers
  def full_address
    [ address, city, administrative_area, postal_code, country ]
      .compact
      .reject(&:blank?)
      .join(", ")
  end

  def location_summary
    [ city, administrative_area, country ].compact.reject(&:blank?).join(", ")
  end

  def geocoded?
    latitude.present? && longitude.present?
  end

  def location_fields_changed?
    address_changed? || city_changed? || administrative_area_changed? ||
    postal_code_changed? || country_changed?
  end

  # Display helpers
  def display_name
    name
  end

  def capacity_range
    return "Unknown capacity" unless capacity

    case capacity
    when 0..500
      "Intimate (Under 500)"
    when 501..2000
      "Mid-size (500-2,000)"
    when 2001..10000
      "Large (2,000-10,000)"
    else
      "Arena/Stadium (10,000+)"
    end
  end

  def contact_info_present?
    website.present? || email.present? || telephone_number.present?
  end

  private

  def ensure_previous_names_array
    self.previous_names ||= []
  end
end
