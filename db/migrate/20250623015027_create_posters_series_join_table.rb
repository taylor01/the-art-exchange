class CreatePostersSeriesJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :posters, :series do |t|
      t.index [:poster_id, :series_id], unique: true
      t.index [:series_id, :poster_id]
    end
    
    # Add foreign key constraints
    add_foreign_key :posters_series, :posters
    add_foreign_key :posters_series, :series
  end
end
