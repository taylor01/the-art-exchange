class AllowNullUserIdInSearchAnalytics < ActiveRecord::Migration[8.0]
  def change
    change_column_null :search_analytics, :user_id, true
  end
end
