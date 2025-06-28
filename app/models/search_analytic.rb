# frozen_string_literal: true

class SearchAnalytic < ApplicationRecord
  belongs_to :user, optional: true  # Allow anonymous search tracking

  validates :performed_at, presence: true

  scope :recent, -> { where("performed_at >= ?", 30.days.ago) }
  scope :with_query, -> { where.not(query: [ nil, "" ]) }
  scope :with_facets, -> { where.not(facet_filters: nil) }

  def self.track_search(params, user: nil, results_count: 0)
    create!(
      query: params[:q]&.strip.presence,
      facet_filters: extract_facet_filters(params),
      results_count: results_count,
      user: user,
      performed_at: Time.current
    )
  end

  def self.popular_queries(limit: 10)
    with_query
      .recent
      .group(:query)
      .order(Arel.sql("count(*) DESC"))
      .limit(limit)
      .count
  end

  def self.popular_facets(limit: 10)
    with_facets
      .recent
      .map { |record| record.facet_filters&.keys || [] }
      .flatten
      .tally
      .sort_by { |_, count| -count }
      .first(limit)
  end

  private

  def self.extract_facet_filters(params)
    filters = {}
    filters[:artists] = Array(params[:artists]).reject(&:blank?) if params[:artists].present?
    filters[:venues] = Array(params[:venues]).reject(&:blank?) if params[:venues].present?
    filters[:bands] = Array(params[:bands]).reject(&:blank?) if params[:bands].present?
    filters[:years] = Array(params[:years]).reject(&:blank?) if params[:years].present?

    filters.present? ? filters : nil
  end
end
