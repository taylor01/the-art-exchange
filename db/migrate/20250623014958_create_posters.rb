class CreatePosters < ActiveRecord::Migration[8.0]
  def change
    create_table :posters do |t|
      t.string :name, null: false
      t.text :description
      t.date :release_date
      t.decimal :original_price, precision: 8, scale: 2
      t.references :band, null: false, foreign_key: true
      t.references :venue, null: false, foreign_key: true

      t.timestamps
    end
    
    # Add indexes for performance
    add_index :posters, :name
    add_index :posters, :release_date
    add_index :posters, [:band_id, :venue_id]
    add_index :posters, [:release_date, :band_id]
  end
end
