class CreateUserPosters < ActiveRecord::Migration[8.0]
  def change
    create_table :user_posters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :poster, null: false, foreign_key: true
      t.string :status, null: false, default: 'watching'
      t.string :edition_number
      t.text :notes
      t.decimal :purchase_price, precision: 8, scale: 2
      t.date :purchase_date
      t.string :condition
      t.boolean :for_sale, default: false
      t.decimal :asking_price, precision: 8, scale: 2

      t.timestamps
    end

    add_index :user_posters, [ :user_id, :poster_id ]
    add_index :user_posters, :status
    add_index :user_posters, :for_sale
  end
end
