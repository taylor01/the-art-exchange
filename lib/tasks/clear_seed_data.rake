namespace :db do
  desc "Clear all seed data from tables"
  task clear_seed_data: :environment do
    puts "🗑️  Clearing all seed data..."
    
    # Delete in dependency order using ActiveRecord models
    puts "Clearing associations..."
    ActiveRecord::Base.connection.execute("DELETE FROM artists_posters")
    ActiveRecord::Base.connection.execute("DELETE FROM posters_series")
    
    puts "Clearing dependent data..."
    ActiveRecord::Base.connection.execute("DELETE FROM user_posters")
    ActiveRecord::Base.connection.execute("DELETE FROM search_analytics")
    ActiveRecord::Base.connection.execute("DELETE FROM search_shares")
    ActiveRecord::Base.connection.execute("DELETE FROM poster_slug_redirects")
    
    puts "Clearing main data tables..."
    ActiveRecord::Base.connection.execute("DELETE FROM posters")
    ActiveRecord::Base.connection.execute("DELETE FROM users")
    ActiveRecord::Base.connection.execute("DELETE FROM venues")
    ActiveRecord::Base.connection.execute("DELETE FROM artists")
    ActiveRecord::Base.connection.execute("DELETE FROM bands")
    ActiveRecord::Base.connection.execute("DELETE FROM series")
    
    puts "✅ All seed data cleared! You can now run db:seed again."
  end
end