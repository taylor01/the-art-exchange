class AddVisualMetadataToPosters < ActiveRecord::Migration[8.0]
  def change
    add_column :posters, :visual_metadata, :json
  end
end
