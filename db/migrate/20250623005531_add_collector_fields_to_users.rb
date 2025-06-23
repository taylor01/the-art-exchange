class AddCollectorFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    # Profile fields
    add_column :users, :bio, :text
    add_column :users, :location, :string
    add_column :users, :website, :string
    add_column :users, :phone, :string

    # Collector-specific fields
    add_column :users, :collector_since, :date
    add_column :users, :preferred_contact_method, :string, default: 'email'

    # Social media handles
    add_column :users, :instagram_handle, :string
    add_column :users, :twitter_handle, :string

    # Add indexes for commonly searched fields
    add_index :users, :location
    add_index :users, :collector_since
  end
end
