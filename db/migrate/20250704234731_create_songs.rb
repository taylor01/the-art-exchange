class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.string :title, null: false
      t.string :artist_credit
      t.string :slug, null: false
      t.boolean :is_cover_song, default: false
      t.string :original_artist
      t.date :first_performed_at
      t.string :musicbrainz_id
      t.string :spotify_id
      t.json :audio_features

      t.timestamps
    end
    
    add_index :songs, :slug, unique: true
    add_index :songs, :title
    add_index :songs, :is_cover_song
    add_index :songs, :musicbrainz_id
    add_index :songs, :spotify_id
  end
end
