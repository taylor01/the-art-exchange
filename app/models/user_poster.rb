class UserPoster < ApplicationRecord
  belongs_to :user
  belongs_to :poster

  has_many_attached :images

  enum :status, {
    owned: "owned",
    wanted: "wanted",
    watching: "watching"
  }

  enum :condition, {
    mint: "mint",
    near_mint: "near_mint",
    very_fine: "very_fine",
    fine: "fine",
    very_good: "very_good",
    good: "good",
    fair: "fair",
    poor: "poor"
  }

  validates :status, presence: true
  validates :purchase_price, numericality: { greater_than: 0 }, allow_blank: true
  validates :asking_price, numericality: { greater_than: 0 }, allow_blank: true

  scope :owned_by, ->(user) { where(user: user, status: "owned") }
  scope :wanted_by, ->(user) { where(user: user, status: "wanted") }
  scope :watched_by, ->(user) { where(user: user, status: "watching") }
  scope :for_sale, -> { where(for_sale: true) }
  scope :by_poster, ->(poster) { where(poster: poster) }

  def display_name
    "#{poster.display_name}#{edition_number.present? ? " (##{edition_number})" : ''}"
  end

  def formatted_purchase_price
    return "Not specified" unless purchase_price
    "$#{purchase_price}"
  end

  def formatted_asking_price
    return "Not for sale" unless for_sale? && asking_price
    "$#{asking_price}"
  end
end
