class CreateBands < ActiveRecord::Migration[8.0]
  def change
    create_table :bands do |t|
      t.string :name, null: false
      t.string :website

      t.timestamps
    end

    add_index :bands, :name, unique: true
  end
end
