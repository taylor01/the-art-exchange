class CreateShows < ActiveRecord::Migration[8.0]
  def change
    create_table :shows do |t|
      t.references :band, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true
      t.date :show_date, null: false
      t.text :show_notes
      t.timestamp :scraped_at
      t.string :slug, null: false

      t.timestamps
    end
    
    add_index :shows, :slug, unique: true
    add_index :shows, :show_date
    add_index :shows, [:band_id, :venue_id, :show_date], unique: true, name: 'index_shows_on_band_venue_date'
  end
end
