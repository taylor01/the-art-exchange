class AddVenueResearchFields < ActiveRecord::Migration[8.0]
  def change
    add_column :venues, :research_summary, :text
    add_column :venues, :research_confidence, :integer
    add_column :venues, :research_sources, :json, default: []
    add_column :venues, :researched_at, :datetime
    add_column :venues, :research_status, :string, default: 'pending'
    
    add_index :venues, :research_status
    add_index :venues, :researched_at
    add_index :venues, :research_confidence
  end
end