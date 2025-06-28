# frozen_string_literal: true

class SearchShare < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  validates :search_params, presence: true

  before_validation :generate_token, on: :create

  scope :active, -> { where("expires_at > ?", Time.current) }

  def self.create_for_search(params)
    # Remove blank values and page parameter for sharing
    cleaned_params = params.except(:page, :per_page).reject { |k, v| v.blank? }

    create!(
      search_params: cleaned_params.to_json,
      expires_at: 1.year.from_now
    )
  end

  def expired?
    expires_at <= Time.current
  end

  def parsed_params
    return {} if search_params.blank?
    
    JSON.parse(search_params).with_indifferent_access
  rescue JSON::ParserError
    {}
  end

  private

  def generate_token
    self.token = SecureRandom.alphanumeric(8) while token.blank? || self.class.exists?(token: token)
  end
end
