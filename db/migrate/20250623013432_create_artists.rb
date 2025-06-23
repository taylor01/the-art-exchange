class CreateArtists < ActiveRecord::Migration[8.0]
  def change
    create_table :artists do |t|
      t.string :name, null: false
      t.string :website

      t.timestamps
    end

    add_index :artists, :name, unique: true
  end
end
