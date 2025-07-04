class CreateAlbums < ActiveRecord::Migration[8.0]
  def change
    create_table :albums do |t|
      t.string :title, null: false
      t.references :band, null: false, foreign_key: true
      t.date :release_date
      t.string :album_type, null: false
      t.string :musicbrainz_id
      t.string :spotify_id

      t.timestamps
    end
    
    add_index :albums, [:band_id, :title], unique: true
    add_index :albums, :release_date
    add_index :albums, :album_type
    add_index :albums, :musicbrainz_id
    add_index :albums, :spotify_id
  end
end
