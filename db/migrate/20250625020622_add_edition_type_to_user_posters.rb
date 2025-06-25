class AddEditionTypeToUserPosters < ActiveRecord::Migration[8.0]
  def change
    add_column :user_posters, :edition_type, :string
  end
end
