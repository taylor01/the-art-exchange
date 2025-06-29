namespace :db do
  desc "Clear all seed data from tables"
  task clear_seed_data: :environment do
    puts "🗑️  Clearing all seed data..."
    
    # Disable foreign key checks temporarily
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 0") if ActiveRecord::Base.connection.adapter_name == "MySQL"
    ActiveRecord::Base.connection.execute("SET session_replication_role = replica") if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
    
    # Clear tables in dependency order (associations first, then main tables)
    puts "Clearing associations..."
    ActiveRecord::Base.connection.execute("TRUNCATE artists_posters CASCADE")
    ActiveRecord::Base.connection.execute("TRUNCATE posters_series CASCADE")
    
    puts "Clearing main data tables..."
    ActiveRecord::Base.connection.execute("TRUNCATE user_posters CASCADE")
    ActiveRecord::Base.connection.execute("TRUNCATE posters CASCADE")
    ActiveRecord::Base.connection.execute("TRUNCATE users CASCADE")
    ActiveRecord::Base.connection.execute("TRUNCATE venues CASCADE") 
    ActiveRecord::Base.connection.execute("TRUNCATE artists CASCADE")
    ActiveRecord::Base.connection.execute("TRUNCATE bands CASCADE")
    ActiveRecord::Base.connection.execute("TRUNCATE series CASCADE")
    
    # Clear other data tables
    puts "Clearing other data tables..."
    ActiveRecord::Base.connection.execute("TRUNCATE search_analytics CASCADE")
    ActiveRecord::Base.connection.execute("TRUNCATE search_shares CASCADE")
    ActiveRecord::Base.connection.execute("TRUNCATE poster_slug_redirects CASCADE")
    
    # Re-enable foreign key checks
    ActiveRecord::Base.connection.execute("SET FOREIGN_KEY_CHECKS = 1") if ActiveRecord::Base.connection.adapter_name == "MySQL"
    ActiveRecord::Base.connection.execute("SET session_replication_role = DEFAULT") if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
    
    puts "✅ All seed data cleared! You can now run db:seed again."
  end
end