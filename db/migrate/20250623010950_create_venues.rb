class CreateVenues < ActiveRecord::Migration[8.0]
  def change
    create_table :venues do |t|
      # Basic venue information
      t.string :name, null: false
      t.text :address
      t.string :city
      t.string :administrative_area  # state/province/region for international support
      t.string :postal_code
      t.string :country, default: 'US'
      
      # Geocoding coordinates (precision: 10, scale: 6 for ~1 meter accuracy)
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      
      # Contact information
      t.string :website
      t.string :email
      t.string :telephone_number
      
      # Venue details
      t.integer :capacity
      t.string :venue_type, default: 'other'
      t.string :status, default: 'active'
      t.text :description
      
      # Name history tracking
      t.json :previous_names, default: []

      t.timestamps
    end
    
    # Indexes for performance
    add_index :venues, :name
    add_index :venues, [:city, :administrative_area]
    add_index :venues, [:latitude, :longitude]
    add_index :venues, :venue_type
    add_index :venues, :status
    add_index :venues, :country
  end
end
