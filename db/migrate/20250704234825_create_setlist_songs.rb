class CreateSetlistSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :setlist_songs do |t|
      t.references :show, null: false, foreign_key: true
      t.references :song, null: false, foreign_key: true
      t.string :set_type, null: false
      t.integer :position, null: false
      t.json :notes

      t.timestamps
    end
    
    add_index :setlist_songs, [:show_id, :set_type, :position], unique: true, name: 'index_setlist_songs_on_show_set_position'
    add_index :setlist_songs, :set_type
  end
end
