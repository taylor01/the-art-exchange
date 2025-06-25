class MakeBandAndVenueOptionalOnPosters < ActiveRecord::Migration[8.0]
  def change
    change_column_null :posters, :band_id, true
    change_column_null :posters, :venue_id, true
  end
end
