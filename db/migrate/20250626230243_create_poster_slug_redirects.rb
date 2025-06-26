class CreatePosterSlugRedirects < ActiveRecord::Migration[8.0]
  def change
    create_table :poster_slug_redirects do |t|
      t.string :old_slug
      t.references :poster, null: false, foreign_key: true

      t.timestamps
    end
    add_index :poster_slug_redirects, :old_slug, unique: true
  end
end
