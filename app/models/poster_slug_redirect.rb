class PosterSlugRedirect < ApplicationRecord
  belongs_to :poster

  validates :old_slug, presence: true, uniqueness: true
  validates :poster, presence: true

  # Prevent redirects to current slugs
  validate :old_slug_not_current_slug

  scope :by_old_slug, ->(slug) { where(old_slug: slug) }

  private

  def old_slug_not_current_slug
    return unless poster&.slug.present?

    if old_slug == poster.slug
      errors.add(:old_slug, "cannot be the same as the current poster slug")
    end
  end
end
