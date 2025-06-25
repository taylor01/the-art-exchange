class CreateSearchAnalytics < ActiveRecord::Migration[8.0]
  def change
    create_table :search_analytics do |t|
      t.string :query
      t.json :facet_filters
      t.integer :results_count
      t.references :user, null: true, foreign_key: true  # Allow anonymous tracking
      t.datetime :performed_at

      t.timestamps
    end
  end
end
