class CreateVenueNames < ActiveRecord::Migration[8.0]
  def change
    create_table :venue_names do |t|
      t.references :venue, null: false, foreign_key: true
      t.string :name, null: false
      t.date :start_date
      t.date :end_date
      t.boolean :current, default: false

      t.timestamps
    end
    
    add_index :venue_names, :current
    add_index :venue_names, :name
    add_index :venue_names, [:venue_id, :current]
    add_index :venue_names, [:name, :current]
    
    # Add trigram index for fuzzy searching on venue names
    add_index :venue_names, :name, name: 'index_venue_names_on_name_gin', 
              opclass: :gin_trgm_ops, using: :gin
  end
end
