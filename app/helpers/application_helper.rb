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
end
