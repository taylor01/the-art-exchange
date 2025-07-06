class CreateClaudeVenueConsultations < ActiveRecord::Migration[8.0]
  def change
    create_table :claude_venue_consultations do |t|
      t.references :venue, null: false, foreign_key: true
      t.string :original_venue_name, null: false
      t.string :location, null: false
      t.date :show_date, null: false
      t.text :prompt_sent
      t.json :response_json
      t.string :model_version, default: 'claude-3-haiku-20240307'
      t.integer :confidence
      t.boolean :match_found
      t.text :reasoning

      t.timestamps
    end

    add_index :claude_venue_consultations, :original_venue_name
    add_index :claude_venue_consultations, [ :location, :show_date ]
    add_index :claude_venue_consultations, :match_found
    add_index :claude_venue_consultations, :confidence
    add_index :claude_venue_consultations, :created_at
  end
end
