class AddShowIdToPosters < ActiveRecord::Migration[8.0]
  def change
    add_reference :posters, :show, null: true, foreign_key: true
  end
end
