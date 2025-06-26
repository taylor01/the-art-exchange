module ApplicationHelper
  # Convert cents to formatted dollar amount
  def format_price_from_cents(cents)
    return "Price Unknown" if cents.blank?

    dollars = cents.to_f / 100
    "$#{number_with_precision(dollars, precision: 2, delimiter: ',')}"
  end

  # Convert cents to dollar value for display (without formatting)
  def cents_to_dollars(cents)
    return 0 if cents.blank?
    cents.to_f / 100
  end

  # Social Media Meta Tag Helpers
  def poster_meta_title(poster)
    "#{poster.name} - #{poster.event_summary} | The Art Exchange"
  end

  def poster_meta_description(poster)
    description = []
    description << poster.name
    description << "by #{poster.artists.pluck(:name).join(', ')}" if poster.artists.any?
    description << poster.event_summary if poster.event_summary.present?
    description << "Original price: #{poster.formatted_price}" if poster.formatted_price.present?
    description << poster.description.truncate(100) if poster.description.present?
    
    description.join(" - ")
  end

  def poster_meta_image_url(poster)
    return nil unless poster.image.attached?
    
    # Use the detail image for social media sharing
    url_for(poster.detail_image_for_display)
  end

  def default_meta_image_url
    # Return a default image URL for pages without specific images
    asset_url('logo/the_art_exchange.svg')
  end

  def site_meta_title
    "The Art Exchange - Community-driven marketplace for art poster collectors"
  end

  def site_meta_description
    "Connect, discover, and trade with fellow art poster collectors. Browse thousands of concert posters, art prints, and collectible artwork from venues and artists worldwide."
  end
end
