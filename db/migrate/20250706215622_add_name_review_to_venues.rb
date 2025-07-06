class AddNameReviewToVenues < ActiveRecord::Migration[8.0]
  def change
    add_column :venues, :name_needs_review, :boolean
    add_column :venues, :suggested_current_name, :string
  end
end
