class AddClaudeFieldsToVenues < ActiveRecord::Migration[8.0]
  def change
    add_column :venues, :claude_matched, :boolean, default: false
    add_column :venues, :claude_confidence, :integer
    add_column :venues, :claude_reasoning, :text

    add_index :venues, :claude_matched
    add_index :venues, :claude_confidence
  end
end
