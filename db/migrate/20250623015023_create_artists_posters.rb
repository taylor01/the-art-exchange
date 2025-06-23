class CreateArtistsPosters < ActiveRecord::Migration[8.0]
  def change
    create_table :artists_posters do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :poster, null: false, foreign_key: true

      t.timestamps
    end
    
    # Add indexes for performance and uniqueness
    add_index :artists_posters, [:artist_id, :poster_id], unique: true
    add_index :artists_posters, [:poster_id, :artist_id]
  end
end
