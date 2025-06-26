class Poster < ApplicationRecord
  include PriceConversion

  # Visual metadata accessors
  def metadata_art_style
    visual_metadata&.dig("visual", "art_style")
  end

  def metadata_color_palette
    visual_metadata&.dig("visual", "color_palette")
  end

  def metadata_mood
    visual_metadata&.dig("thematic", "mood")
  end

  def metadata_themes
    visual_metadata&.dig("thematic", "primary_themes")
  end

  def metadata_elements
    visual_metadata&.dig("thematic", "elements")
  end

  def metadata_display_context
    visual_metadata&.dig("market_appeal", "display_context")
  end

  def metadata_wall_colors
    visual_metadata&.dig("market_appeal", "wall_color_match")
  end

  def has_metadata?
    visual_metadata.present?
  end

  def metadata_version_current?
    metadata_version == PosterMetadataService::CURRENT_METADATA_VERSION
  end

  def metadata_version_outdated?
    has_metadata? && !metadata_version_current?
  end

  def metadata_version_missing?
    has_metadata? && metadata_version.blank?
  end

  def needs_reanalysis?
    !has_metadata? || metadata_version_outdated? || metadata_version_missing?
  end

  # Associations
  belongs_to :band, optional: true
  belongs_to :venue, optional: true
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :series
  has_many :user_posters, dependent: :destroy
  has_many :users, through: :user_posters

  # Image attachment - one official image per poster/variant
  has_one_attached :image

  # Image variant helpers with safe fallback to original image
  def thumbnail_image_for_display
    return image unless image.attached?

    # Check if variant processing is available
    if self.class.variant_processing_available?
      image.variant(resize_to_fill: [ 400, 600 ])
    else
      image
    end
  end

  def small_thumbnail_image_for_display
    return image unless image.attached?

    # Check if variant processing is available
    if self.class.variant_processing_available?
      image.variant(resize_to_fill: [ 100, 125 ])
    else
      image
    end
  end

  # Optimized grid thumbnail for poster grid display (~214x285 actual size)
  def grid_thumbnail_image_for_display
    return image unless image.attached?

    # Check if variant processing is available
    if self.class.variant_processing_available?
      image.variant(resize_to_fill: [ 230, 300 ])
    else
      image
    end
  end

  # Ultra-small blur placeholder for progressive loading
  def blur_placeholder_image_for_display
    return image unless image.attached?

    # Check if variant processing is available
    if self.class.variant_processing_available?
      image.variant(resize_to_fill: [ 20, 27 ], quality: 30)
    else
      image
    end
  end

  # Medium-sized image for show page display (optimized for detail viewing)
  def detail_image_for_display
    return image unless image.attached?

    # Check if variant processing is available
    if self.class.variant_processing_available?
      image.variant(resize_to_fill: [ 600, 800 ])
    else
      image
    end
  end

  def thumbnail_url
    return nil unless image.attached?
    Rails.application.routes.url_helpers.url_for(thumbnail_image_for_display)
  rescue => e
    Rails.logger.warn "Failed to generate thumbnail URL for poster #{id}: #{e.message}"
    Rails.application.routes.url_helpers.url_for(image)
  end

  def small_thumbnail_url
    return nil unless image.attached?
    Rails.application.routes.url_helpers.url_for(small_thumbnail_image_for_display)
  rescue => e
    Rails.logger.warn "Failed to generate small thumbnail URL for poster #{id}: #{e.message}"
    Rails.application.routes.url_helpers.url_for(image)
  end

  def grid_thumbnail_url
    return nil unless image.attached?
    Rails.application.routes.url_helpers.url_for(grid_thumbnail_image_for_display)
  rescue => e
    Rails.logger.warn "Failed to generate grid thumbnail URL for poster #{id}: #{e.message}"
    Rails.application.routes.url_helpers.url_for(image)
  end

  def blur_placeholder_url
    return nil unless image.attached?
    Rails.application.routes.url_helpers.url_for(blur_placeholder_image_for_display)
  rescue => e
    Rails.logger.warn "Failed to generate blur placeholder URL for poster #{id}: #{e.message}"
    Rails.application.routes.url_helpers.url_for(image)
  end

  def detail_image_url
    return nil unless image.attached?
    Rails.application.routes.url_helpers.url_for(detail_image_for_display)
  rescue => e
    Rails.logger.warn "Failed to generate detail image URL for poster #{id}: #{e.message}"
    Rails.application.routes.url_helpers.url_for(image)
  end

  # Class method to check if variant processing is available
  def self.variant_processing_available?
    return @variant_processing_available if defined?(@variant_processing_available)

    @variant_processing_available = begin
      # Try to load the image processing library
      require "vips"
      true
    rescue LoadError
      Rails.logger.warn "Variant processing unavailable: libvips not installed"
      false
    end
  end

  # Include search functionality
  include PgSearch::Model
  pg_search_scope :search_by_name_and_description,
    against: [ :name, :description ],
    associated_against: {
      band: [ :name ],
      venue: [ :name, :city ],
      artists: [ :name ],
      series: [ :name ]
    },
    using: {
      tsearch: { prefix: true }
    }

  # Validations
  validates :name, presence: true
  validates :release_date, presence: true
  validates :original_price, numericality: { greater_than: 0 }, allow_blank: true
  validates :edition_size, numericality: { greater_than: 0, only_integer: true }, allow_blank: true

  # Callbacks
  before_validation :normalize_name

  # Scopes
  scope :by_year, ->(year) { where("EXTRACT(year FROM release_date) = ?", year) }
  scope :by_decade, ->(decade) { where("EXTRACT(year FROM release_date) BETWEEN ? AND ?", decade, decade + 9) }
  scope :recent, -> { where("release_date >= ?", 5.years.ago) }
  scope :vintage, -> { where("release_date < ?", 30.years.ago) }
  scope :golden_age, -> { where("release_date BETWEEN ? AND ?", Date.new(1965), Date.new(1975)) }
  scope :with_price, -> { where.not(original_price: nil) }
  scope :chronological, -> { order(:release_date, :name) }
  scope :alphabetical, -> { order(:name) }
  scope :by_band, ->(band) { where(band: band) }
  scope :by_venue, ->(venue) { where(venue: venue) }
  scope :by_artist, ->(artist) { joins(:artists).where(artists: { id: artist.id }) }
  scope :in_series, ->(series) { joins(:series).where(series: { id: series.id }) }

  # Display helpers
  def display_name
    parts = [ name ]
    parts << "#{band.name} at #{venue.name}" if band && venue
    parts.join(" - ")
  end

  def full_title
    parts = [ name ]
    parts << band.name if band
    parts << venue.name if venue
    parts << release_date.strftime("%Y") if release_date
    parts.compact.join(" • ")
  end

  def event_summary
    if band && venue
      return "#{band.name} at #{venue.name}" unless release_date
      "#{band.name} at #{venue.name} (#{release_date.strftime('%B %d, %Y')})"
    else
      return name unless release_date
      "#{name} (#{release_date.strftime('%B %d, %Y')})"
    end
  end

  def short_title
    parts = [ name ]
    parts << release_date.year.to_s if release_date
    parts.join(" ")
  end

  # Date helpers
  def year
    release_date&.year
  end

  def decade
    return nil unless year
    "#{(year / 10) * 10}s"
  end

  def formatted_date
    return "Date Unknown" unless release_date
    release_date.strftime("%B %d, %Y")
  end

  # Era helpers
  def vintage?
    release_date && release_date < 30.years.ago
  end

  def modern?
    release_date && release_date >= 10.years.ago
  end

  def golden_age?
    release_date && release_date.between?(Date.new(1965), Date.new(1975))
  end

  # Price helpers
  def has_price?
    original_price.present?
  end

  def formatted_price
    format_cents_as_currency(original_price)
  end

  # Get original price in dollars for forms
  def original_price_in_dollars
    cents_to_dollars(original_price)
  end

  # Set original price from dollars
  def original_price_in_dollars=(dollars)
    self.original_price = dollars_to_cents(dollars)
  end

  # Artist helpers
  def artist_names
    artists.pluck(:name).join(", ")
  end

  def primary_artist
    artists.first
  end

  def collaborative?
    artists.count > 1
  end

  def solo_artist?
    artists.count == 1
  end

  # Series helpers
  def series_names
    series.pluck(:name).join(", ")
  end

  def in_series?
    series.any?
  end

  def series_count
    series.count
  end

  # Location helpers
  def venue_location
    venue&.location_summary
  end

  def venue_city
    venue&.city
  end

  # Search helpers
  def self.search_all_fields(query)
    search_by_name_and_description(query)
  end

  def self.find_by_event(band_name, venue_name, date = nil)
    scope = joins(:band, :venue)
            .where("bands.name ILIKE ? AND venues.name ILIKE ?", "%#{band_name}%", "%#{venue_name}%")
    scope = scope.where(release_date: date) if date
    scope
  end

  private

  def normalize_name
    self.name = name&.strip
  end
end
