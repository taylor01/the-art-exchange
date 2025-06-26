class AddSlugToPosters < ActiveRecord::Migration[8.0]
  def up
    # Add slug column
    add_column :posters, :slug, :string
    
    # Generate slugs for existing posters
    populate_existing_slugs
    
    # Add unique index after populating data
    add_index :posters, :slug, unique: true
  end

  def down
    remove_index :posters, :slug
    remove_column :posters, :slug
  end

  private

  def populate_existing_slugs
    say "Generating slugs for existing posters..."
    
    Poster.find_in_batches(batch_size: 100) do |batch|
      batch.each do |poster|
        poster.send(:generate_slug)
        poster.save!(validate: false) # Skip validations during migration
      rescue => e
        say "Failed to generate slug for poster #{poster.id}: #{e.message}", true
      end
    end
    
    say "Slug generation completed"
  end
end
