class CreateAlbumSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :album_songs do |t|
      t.references :album, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.integer :track_number
      t.integer :disc_number, default: 1

      t.timestamps
    end
    
    add_index :album_songs, [:album_id, :song_id], unique: true
    add_index :album_songs, [:album_id, :track_number, :disc_number], unique: true, name: 'index_album_songs_on_album_track_disc'
  end
end
