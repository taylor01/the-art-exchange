class CreateSearchShares < ActiveRecord::Migration[8.0]
  def change
    create_table :search_shares do |t|
      t.string :token
      t.text :search_params
      t.datetime :expires_at

      t.timestamps
    end
  end
end
