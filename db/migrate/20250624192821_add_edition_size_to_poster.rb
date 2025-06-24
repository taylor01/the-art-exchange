class AddEditionSizeToPoster < ActiveRecord::Migration[8.0]
  def change
    add_column :posters, :edition_size, :integer, null: true
  end
end
