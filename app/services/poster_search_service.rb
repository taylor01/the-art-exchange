# frozen_string_literal: true

class PosterSearchService
  def initialize(params = {})
    @query = params[:q]&.strip
    @artist_ids = Array(params[:artists]).reject(&:blank?).map(&:to_i)
    @venue_ids = Array(params[:venues]).reject(&:blank?).map(&:to_i)
    @band_ids = Array(params[:bands]).reject(&:blank?).map(&:to_i)
    @years = Array(params[:years]).reject(&:blank?).map(&:to_i)
    @page = params[:page] || 1
    @per_page = params[:per_page] || 20
  end

  def search
    results = base_query
    results = apply_text_search(results)
    results = apply_facet_filters(results)
    results = apply_ordering(results)
    paginate_results(results)
  end

  def facet_options
    Rails.cache.fetch("poster_search_facets", expires_in: 1.hour) do
      {
        artists: available_artists,
        venues: available_venues,
        bands: available_bands,
        years: available_years
      }
    end
  end

  def search_params
    {
      q: @query,
      artists: @artist_ids,
      venues: @venue_ids,
      bands: @band_ids,
      years: @years
    }.reject { |_, v| v.blank? }
  end

  private

  def base_query
    Poster.includes(:band, :venue, :artists, image_attachment: :blob)
  end

  def apply_text_search(scope)
    return scope if @query.blank?

    scope.search_by_name_and_description(@query)
  end

  def apply_facet_filters(scope)
    scope = scope.joins(:artists).where(artists: { id: @artist_ids }) if @artist_ids.any?
    scope = scope.where(venue_id: @venue_ids) if @venue_ids.any?
    scope = scope.where(band_id: @band_ids) if @band_ids.any?
    scope = scope.where("EXTRACT(year FROM release_date) IN (?)", @years) if @years.any?
    scope
  end

  def apply_ordering(scope)
    if @query.present?
      # When searching, order by relevance (pg_search handles this)
      scope
    else
      # Default browsing order - most recent first
      scope.chronological.reverse_order
    end
  end

  def paginate_results(scope)
    scope.page(@page).per(@per_page)
  end

  def available_artists
    Artist.joins(:posters)
          .select("artists.*, COUNT(posters.id) as poster_count")
          .group("artists.id")
          .order("poster_count DESC, artists.name ASC")
          .limit(100)
          .map { |artist| { id: artist.id, name: artist.name } }
  end

  def available_venues
    Venue.joins(:posters)
         .select("venues.*, COUNT(posters.id) as poster_count")
         .group("venues.id")
         .order("poster_count DESC, venues.name ASC")
         .limit(100)
         .map { |venue| { id: venue.id, name: venue.name, city: venue.city } }
  end

  def available_bands
    Band.joins(:posters)
        .select("bands.*, COUNT(posters.id) as poster_count")
        .group("bands.id")
        .order("poster_count DESC, bands.name ASC")
        .limit(50)
        .map { |band| { id: band.id, name: band.name } }
  end

  def available_years
    results = Poster.connection.execute(
      "SELECT EXTRACT(year FROM release_date)::integer as year " +
      "FROM posters " +
      "WHERE release_date IS NOT NULL " +
      "GROUP BY EXTRACT(year FROM release_date) " +
      "ORDER BY year DESC " +
      "LIMIT 50"
    )
    results.map { |row| { year: row["year"].to_i } }
  end
end
