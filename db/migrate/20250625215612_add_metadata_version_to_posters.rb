class AddMetadataVersionToPosters < ActiveRecord::Migration[8.0]
  def change
    add_column :posters, :metadata_version, :string
  end
end
