module PriceConversion
  extend ActiveSupport::Concern

  module ClassMethods
    # Convert dollar amount to cents for storage
    def dollars_to_cents(dollars)
      return nil if dollars.blank?
      (dollars.to_f * 100).round
    end

    # Convert cents to dollars for display
    def cents_to_dollars(cents)
      return nil if cents.blank?
      cents.to_f / 100
    end
  end

  # Instance methods for easy access
  def dollars_to_cents(dollars)
    self.class.dollars_to_cents(dollars)
  end

  def cents_to_dollars(cents)
    self.class.cents_to_dollars(cents)
  end

  # Format cents as currency
  def format_cents_as_currency(cents)
    return "Price Unknown" if cents.blank?
    dollars = cents_to_dollars(cents)
    ActionController::Base.helpers.number_to_currency(dollars)
  end
end
