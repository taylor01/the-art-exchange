class AddSearchIndexesToTables < ActiveRecord::Migration[8.0]
  def change
    # Enable trigram extension for better text search
    enable_extension "pg_trgm" unless extension_enabled?("pg_trgm")

    # Indexes for search analytics
    add_index :search_analytics, :performed_at unless index_exists?(:search_analytics, :performed_at)
    add_index :search_analytics, :query unless index_exists?(:search_analytics, :query)
    add_index :search_analytics, [ :query, :performed_at ] unless index_exists?(:search_analytics, [ :query, :performed_at ])

    # Indexes for search shares
    add_index :search_shares, :token, unique: true unless index_exists?(:search_shares, :token)
    add_index :search_shares, :expires_at unless index_exists?(:search_shares, :expires_at)
    add_index :search_shares, [ :token, :expires_at ] unless index_exists?(:search_shares, [ :token, :expires_at ])

    # Additional poster indexes for search performance (only add new ones)
    add_index :posters, :name, using: :gin, opclass: :gin_trgm_ops, name: "index_posters_on_name_gin" unless index_exists?(:posters, :name, name: "index_posters_on_name_gin")
    add_index :posters, :description, using: :gin, opclass: :gin_trgm_ops unless index_exists?(:posters, :description)

    # Indexes for facet aggregations
    add_index :artists_posters, [ :artist_id, :poster_id ] unless index_exists?(:artists_posters, [ :artist_id, :poster_id ])
    add_index :posters_series, [ :series_id, :poster_id ] unless index_exists?(:posters_series, [ :series_id, :poster_id ])

    # Composite indexes for common search patterns
    add_index :posters, [ :venue_id, :release_date ] unless index_exists?(:posters, [ :venue_id, :release_date ])
    add_index :posters, [ :band_id, :release_date ] unless index_exists?(:posters, [ :band_id, :release_date ])

    # Year extraction index for faceted search
    add_index :posters, "EXTRACT(year FROM release_date)", name: "index_posters_on_year" unless index_exists?(:posters, "EXTRACT(year FROM release_date)", name: "index_posters_on_year")
  end
end
