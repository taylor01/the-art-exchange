class AddHistoricalDataToVenues < ActiveRecord::Migration[8.0]
  def change
    add_column :venues, :historical_significance, :json
    add_column :venues, :unique_features, :json
  end
end
