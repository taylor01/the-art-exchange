class CreateSeries < ActiveRecord::Migration[8.0]
  def change
    create_table :series do |t|
      t.string :name, null: false
      t.text :description
      t.integer :year
      t.integer :total_count

      t.timestamps
    end

    add_index :series, :name
    add_index :series, :year
  end
end
