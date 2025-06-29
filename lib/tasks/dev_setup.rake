namespace :dev do
  desc "Reset development database for clean migration testing"
  task reset_for_migration: :environment do
    puts "🔄 Resetting development database for clean migration..."
    
    # Ensure we're in development environment
    unless Rails.env.development?
      puts "❌ This task can only be run in development environment"
      exit 1
    end
    
    # Drop existing database
    puts "📥 Dropping existing development database..."
    Rake::Task["db:drop"].invoke
    
    # Create fresh database
    puts "🔨 Creating fresh development database..."
    Rake::Task["db:create"].invoke
    
    # Run all migrations
    puts "📋 Running Rails migrations..."
    Rake::Task["db:migrate"].invoke
    
    # Verify database is ready
    puts "✅ Development database reset complete!"
    puts "📊 Database ready for clean migration run"
    
    # Show current database connection info
    config = ActiveRecord::Base.connection_db_config
    puts "🔗 Connected to: #{config.database}"
    puts "🏠 Host: #{config.host || 'localhost'}"
  end

  desc "Validate development environment is ready for migration"
  task validate_migration_ready: :environment do
    puts "🔍 Validating development environment for migration..."
    
    # Check database connection
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      puts "✅ Database connection: OK"
    rescue => e
      puts "❌ Database connection failed: #{e.message}"
      exit 1
    end
    
    # Check if tables are empty (ready for migration)
    tables_to_check = %w[users venues artists bands series posters user_posters]
    empty_tables = []
    non_empty_tables = []
    
    tables_to_check.each do |table|
      begin
        count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first['count'].to_i
        if count == 0
          empty_tables << table
        else
          non_empty_tables << "#{table} (#{count} records)"
        end
      rescue ActiveRecord::StatementInvalid
        puts "⚠️  Table #{table} does not exist (migrations may need to run)"
      end
    end
    
    if non_empty_tables.any?
      puts "⚠️  Found existing data in tables:"
      non_empty_tables.each { |table| puts "   • #{table}" }
      puts "💡 Run 'rake dev:reset_for_migration' to clean database"
    else
      puts "✅ All migration target tables are empty"
    end
    
    # Check for production backup database connection
    begin
      # Test production backup connection (used by migration tool)
      conn = PG.connect(
        host: "localhost",
        dbname: "art_exchange_production_backup",
        user: ENV["USER"] || `whoami`.strip
      )
      conn.close
      puts "✅ Production backup database connection: OK"
    rescue PG::Error => e
      puts "❌ Production backup database connection failed: #{e.message}"
      puts "💡 Ensure you have restored the production backup to 'art_exchange_production_backup'"
    end
    
    puts "🚀 Environment validation complete!"
  end

  desc "Create production database dump after successful migration"
  task create_production_dump: :environment do
    puts "📦 Creating production database dump from development data..."
    
    # Ensure we're in development environment
    unless Rails.env.development?
      puts "❌ This task can only be run in development environment"
      exit 1
    end
    
    # Get database configuration
    config = ActiveRecord::Base.connection_db_config
    database_name = config.database
    
    # Create timestamp for dump file
    timestamp = Time.current.strftime("%Y%m%d_%H%M%S")
    dump_file = "production_migration_dump_#{timestamp}.sql"
    
    puts "🗄️  Database: #{database_name}"
    puts "📄 Dump file: #{dump_file}"
    
    # Create the dump
    puts "💾 Creating database dump..."
    cmd = "pg_dump #{database_name} > #{dump_file}"
    
    if system(cmd)
      file_size = File.size(dump_file) / 1024.0 / 1024.0
      puts "✅ Database dump created successfully!"
      puts "📊 File size: #{file_size.round(2)} MB"
      puts "📁 Location: #{File.absolute_path(dump_file)}"
      
      # Show record counts for verification
      puts "\n📈 Migrated data summary:"
      tables_to_count = %w[users venues artists bands series posters user_posters]
      tables_to_count.each do |table|
        begin
          count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM #{table}").first['count'].to_i
          puts "   • #{table.humanize}: #{count}"
        rescue => e
          puts "   • #{table.humanize}: Error (#{e.message})"
        end
      end
      
      puts "\n🚀 Ready for production deployment!"
      puts "💡 Transfer #{dump_file} to production server and import with:"
      puts "   psql $DATABASE_URL < #{dump_file}"
      
    else
      puts "❌ Database dump failed!"
      exit 1
    end
  end
end