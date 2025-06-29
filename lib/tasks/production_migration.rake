# frozen_string_literal: true

namespace :migrate do
  desc "Analyze production database backup for migration planning"
  task analyze_production: :environment do
    puts "🔍 Analyzing production database backup..."

    # This task will connect to a temporary database with the production backup loaded
    # For now, we'll document what we expect based on MIGRATION.md

    puts "\n📊 Expected Data Volumes (from MIGRATION.md):"
    puts "- Artworks: 773 → Posters"
    puts "- Users: ~750 (estimated)"
    puts "- User Collections: ~500 (estimated)"
    puts "- Transactions: 250 → External Sales"
    puts "- Images: ~2,000 total (968 artwork + 981 transaction)"

    puts "\n✅ Production schema files available:"
    schema_files = Dir.glob(Rails.root.join("migration", "*.sql"))
    schema_files.each { |file| puts "  - #{File.basename(file)}" }

    puts "\n📋 Migration phases planned:"
    puts "  Phase 1: Core data (users, venues, artists, bands, series, artworks→posters)"
    puts "  Phase 2: Image migration via ActiveStorage reattachment"
    puts "  Phase 3: External sales feature (transactions)"
    puts "  Phase 4: Validation and cleanup"
  end

  desc "Import core data from production (Phase 1)"
  task import_core_data: :environment do
    puts "🚀 Starting Phase 1: Core Data Migration"

    # Disable all email delivery during migration
    original_delivery_method = ActionMailer::Base.delivery_method
    ActionMailer::Base.delivery_method = :test
    puts "📧 Email delivery disabled for migration (was: #{original_delivery_method})"

    # Invoke subtasks in dependency order
    Rake::Task["migrate:import_users"].invoke
    Rake::Task["migrate:import_venues"].invoke
    Rake::Task["migrate:import_artists"].invoke
    Rake::Task["migrate:import_bands"].invoke
    Rake::Task["migrate:import_series"].invoke
    Rake::Task["migrate:import_posters"].invoke
    Rake::Task["migrate:import_user_collections"].invoke

    # Restore original email delivery method
    ActionMailer::Base.delivery_method = original_delivery_method
    puts "📧 Email delivery restored to: #{original_delivery_method}"

    puts "✅ Phase 1 Core Data Migration Complete!"
  end

  desc "Migrate poster images from S3 source bucket (Phase 2)"
  task migrate_images: :environment do
    puts "🖼️ Starting Phase 2: Image Migration from S3 Source"

    # Validate S3 source configuration
    source_bucket = ENV["SOURCE_S3_BUCKET"] || "the-art-exchange-migration-source"
    source_region = ENV["SOURCE_S3_REGION"] || "us-east-1"

    unless ENV["AWS_ACCESS_KEY_ID"] && ENV["AWS_SECRET_ACCESS_KEY"]
      puts "❌ Missing S3 source credentials. Please set:"
      puts "   AWS_ACCESS_KEY_ID"
      puts "   AWS_SECRET_ACCESS_KEY"
      puts "   SOURCE_S3_REGION (optional, defaults to us-east-1)"
      puts "   SOURCE_S3_BUCKET (optional, defaults to the-art-exchange-migration-source)"
      abort("Missing required S3 credentials")
    end

    puts "🗂️  Source S3 Configuration:"
    puts "   Bucket: #{source_bucket}"
    puts "   Region: #{source_region}"

    # Initialize S3 client for source bucket
    require "aws-sdk-s3"
    s3_client = Aws::S3::Client.new(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: source_region
    )

    # Store original connection
    original_config = ActiveRecord::Base.connection_db_config

    # Connect to production backup database temporarily
    prod_conn = establish_production_connection

    # Get artwork to blob mapping
    puts "📋 Fetching image mappings from production backup..."
    mappings = prod_conn.exec_query('
      SELECT a.record_id as artwork_id, b.key, b.filename, b.content_type, b.byte_size
      FROM active_storage_attachments a
      JOIN active_storage_blobs b ON a.blob_id = b.id
      WHERE a.record_type = \'Artwork\' AND a.name = \'image\'
      ORDER BY a.record_id
    ')

    # Restore development database connection
    ActiveRecord::Base.establish_connection(original_config)

    puts "📊 Found #{mappings.length} image mappings to process"

    # Track migration progress
    successful_migrations = 0
    failed_migrations = 0
    missing_files = 0
    missing_posters = 0

    mappings.each_with_index do |mapping, index|
      artwork_id = mapping["artwork_id"]
      blob_key = mapping["key"]
      filename = mapping["filename"]
      content_type = mapping["content_type"]
      byte_size = mapping["byte_size"]

      # Progress indicator
      if (index + 1) % 50 == 0 || index == 0
        puts "📈 Processing image #{index + 1}/#{mappings.length} (#{((index + 1) * 100.0 / mappings.length).round(1)}%)"
      end

      begin
        # Find corresponding poster in new system
        poster = Poster.find_by(id: artwork_id)
        unless poster
          puts "⚠️  Poster not found for artwork_id #{artwork_id}, skipping" if index < 10
          missing_posters += 1
          next
        end

        # Skip if poster already has an image attached
        if poster.image.attached?
          successful_migrations += 1
          next
        end

        # Map database blob key to S3 source key
        s3_key = map_blob_key_to_s3_path(blob_key)

        # Download image from S3 source bucket
        begin
          response = s3_client.get_object(
            bucket: source_bucket,
            key: s3_key
          )

          # Attach image to poster using S3 data stream
          poster.image.attach(
            io: response.body,
            filename: filename,
            content_type: content_type
          )

          # Verify attachment was successful
          if poster.image.attached?
            successful_migrations += 1
            puts "✅ Attached #{filename} to poster #{poster.id} (#{poster.name})" if index < 10 # Show first 10 for verification
          else
            puts "❌ Failed to attach image to poster #{poster.id}"
            failed_migrations += 1
          end

        rescue Aws::S3::Errors::NoSuchKey
          puts "⚠️  S3 object not found: #{s3_key}, skipping poster #{poster.id}" if index < 10
          missing_files += 1
          next
        rescue Aws::S3::Errors::ServiceError => e
          puts "❌ S3 error for #{s3_key}: #{e.message}"
          failed_migrations += 1
          next
        end

      rescue => e
        puts "❌ Error processing image for artwork #{artwork_id}: #{e.message}"
        failed_migrations += 1
        next
      end
    end

    # Final statistics
    puts "\n📊 Image Migration Complete!"
    puts "✅ Successful: #{successful_migrations}"
    puts "❌ Failed: #{failed_migrations}"
    puts "📁 Missing S3 objects: #{missing_files}"
    puts "📋 Missing posters: #{missing_posters}"
    puts "📈 Success rate: #{(successful_migrations * 100.0 / mappings.length).round(1)}%"

    # Verify total attachments
    total_attached = Poster.joins(:image_attachment).count
    puts "🔗 Total posters with images: #{total_attached}/#{Poster.count}"

    puts "\n🎯 Image Migration from S3 Source Complete!"
  end

  desc "Test image migration with small batch from S3 source"
  task test_image_migration: :environment do
    puts "🧪 Testing S3 Image Migration (5 images)"

    # Validate S3 source configuration
    source_bucket = ENV["SOURCE_S3_BUCKET"] || "the-art-exchange-migration-source"
    source_region = ENV["SOURCE_S3_REGION"] || "us-east-1"

    unless ENV["AWS_ACCESS_KEY_ID"] && ENV["AWS_SECRET_ACCESS_KEY"]
      puts "❌ Missing S3 source credentials for testing"
      puts "✅ Test complete. Configure S3 credentials and run 'rake migrate:migrate_images' for full migration."
      return
    end

    # Initialize S3 client for source bucket
    require "aws-sdk-s3"
    s3_client = Aws::S3::Client.new(
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: source_region
    )

    # Store original connection
    original_config = ActiveRecord::Base.connection_db_config

    # Connect to production backup database temporarily
    prod_conn = establish_production_connection

    # Get small sample of mappings
    mappings = prod_conn.exec_query('
      SELECT a.record_id as artwork_id, b.key, b.filename, b.content_type
      FROM active_storage_attachments a
      JOIN active_storage_blobs b ON a.blob_id = b.id
      WHERE a.record_type = \'Artwork\' AND a.name = \'image\'
      ORDER BY a.record_id
      LIMIT 5
    ')

    # Restore development database connection
    ActiveRecord::Base.establish_connection(original_config)

    puts "📋 Testing with #{mappings.length} images from S3 bucket: #{source_bucket}"

    mappings.each do |mapping|
      artwork_id = mapping["artwork_id"]
      blob_key = mapping["key"]
      filename = mapping["filename"]
      s3_key = map_blob_key_to_s3_path(blob_key)

      poster = Poster.find_by(id: artwork_id)

      # Check if S3 object exists
      s3_exists = false
      s3_size = "N/A"
      begin
        response = s3_client.head_object(bucket: source_bucket, key: s3_key)
        s3_exists = true
        s3_size = "#{(response.content_length / 1024.0).round(1)} KB"
      rescue Aws::S3::Errors::NoSuchKey
        s3_exists = false
      rescue => e
        s3_exists = "Error: #{e.message}"
      end

      puts "🔍 Artwork #{artwork_id} → Poster #{poster&.id} → S3 #{s3_key}"
      puts "   S3 object exists: #{s3_exists}"
      puts "   S3 object size: #{s3_size}"
      puts "   Already attached: #{poster&.image&.attached?}"
      puts ""
    end

    puts "✅ Test complete. Run 'rake migrate:migrate_images' for full migration."
  end

  desc "Import users from production"
  task import_users: :environment do
    puts "👥 Importing users..."

    production_users = fetch_from_production(<<~SQL)
      SELECT id, email, first_name, last_name, is_admin,#{' '}
             created_at, updated_at
      FROM users#{' '}
      ORDER BY id
    SQL

    puts "📊 Found #{production_users.length} users in production"

    imported_count = 0
    skipped_count = 0

    production_users.each_slice(100) do |batch|
      User.transaction do
        batch.each do |prod_user|
          # Skip if user already exists (for resumable migration)
          if User.exists?(id: prod_user["id"])
            skipped_count += 1
            next
          end

          begin
            user = User.new(
              id: prod_user["id"],
              email: prod_user["email"],
              first_name: prod_user["first_name"],
              last_name: prod_user["last_name"],
              admin: prod_user["is_admin"] || false,
              created_at: prod_user["created_at"],
              updated_at: prod_user["updated_at"],
              terms_accepted_at: prod_user["created_at"], # Set terms acceptance to original account creation
              terms_version: "legacy-import" # Mark as legacy users for later re-acceptance
              # Note: Skip encrypted_password - users will need to reset passwords
            )
            user.save!(context: :migration)
            imported_count += 1
            puts "  ✅ Imported user #{prod_user['id']}: #{prod_user['email']}" if imported_count % 50 == 0
          rescue ActiveRecord::RecordInvalid => e
            puts "  ❌ Failed to import user #{prod_user['id']}: #{e.message}"
            skipped_count += 1
          end
        end
      end
    end

    puts "✅ Users migration complete: #{imported_count} imported, #{skipped_count} skipped"
  end

  desc "Import venues from production"
  task import_venues: :environment do
    puts "🏛️  Importing venues..."

    # Disable geocoding during migration since we already have coordinates
    Venue.skip_callback(:validation, :after, :geocode)
    puts "🌍 Geocoding callbacks disabled for migration"

    production_venues = fetch_from_production(<<~SQL)
      SELECT id, name, address, city, state, zip, country,#{' '}
             latitude, longitude, created_at, updated_at
      FROM venues#{' '}
      ORDER BY id
    SQL

    puts "📊 Found #{production_venues.length} venues in production"

    imported_count = 0
    skipped_count = 0

    production_venues.each_slice(50) do |batch|
      Venue.transaction do
        batch.each do |prod_venue|
          # Skip if venue already exists (for resumable migration)
          if Venue.exists?(id: prod_venue["id"])
            skipped_count += 1
            next
          end

          begin
            Venue.create!(
              id: prod_venue["id"],
              name: prod_venue["name"],
              address: prod_venue["address"],
              city: prod_venue["city"],
              administrative_area: prod_venue["state"], # state → administrative_area
              postal_code: prod_venue["zip"],           # zip → postal_code
              country: prod_venue["country"] || "US",
              latitude: prod_venue["latitude"]&.to_f,
              longitude: prod_venue["longitude"]&.to_f,
              venue_type: "other", # Default since we don't have type data in production
              created_at: prod_venue["created_at"],
              updated_at: prod_venue["updated_at"]
            )
            imported_count += 1
            puts "  ✅ Imported venue #{prod_venue['id']}: #{prod_venue['name']}" if imported_count % 25 == 0
          rescue ActiveRecord::RecordInvalid => e
            puts "  ❌ Failed to import venue #{prod_venue['id']}: #{e.message}"
            skipped_count += 1
          end
        end
      end
    end

    puts "✅ Venues migration complete: #{imported_count} imported, #{skipped_count} skipped"
  end

  desc "Import artists from production"
  task import_artists: :environment do
    puts "🎨 Importing artists..."

    production_artists = fetch_from_production(<<~SQL)
      SELECT id, name, website, created_at, updated_at
      FROM artists#{' '}
      ORDER BY id
    SQL

    puts "📊 Found #{production_artists.length} artists in production"

    imported_count = 0
    skipped_count = 0

    production_artists.each_slice(50) do |batch|
      Artist.transaction do
        batch.each do |prod_artist|
          # Skip if artist already exists (for resumable migration)
          if Artist.exists?(id: prod_artist["id"])
            skipped_count += 1
            next
          end

          begin
            Artist.create!(
              id: prod_artist["id"],
              name: prod_artist["name"],
              website: normalize_website_url(prod_artist["website"]),
              created_at: prod_artist["created_at"],
              updated_at: prod_artist["updated_at"]
              # Skip: ticker_symbol (unused feature)
            )
            imported_count += 1
            puts "  ✅ Imported artist #{prod_artist['id']}: #{prod_artist['name']}" if imported_count % 25 == 0
          rescue ActiveRecord::RecordInvalid => e
            puts "  ❌ Failed to import artist #{prod_artist['id']}: #{e.message}"
            skipped_count += 1
          end
        end
      end
    end

    puts "✅ Artists migration complete: #{imported_count} imported, #{skipped_count} skipped"
  end

  desc "Import bands from production"
  task import_bands: :environment do
    puts "🎵 Importing bands..."

    production_bands = fetch_from_production(<<~SQL)
      SELECT id, name, website, created_at, updated_at
      FROM bands#{' '}
      ORDER BY id
    SQL

    puts "📊 Found #{production_bands.length} bands in production"

    imported_count = 0
    skipped_count = 0

    production_bands.each_slice(50) do |batch|
      Band.transaction do
        batch.each do |prod_band|
          # Skip if band already exists (for resumable migration)
          if Band.exists?(id: prod_band["id"])
            skipped_count += 1
            next
          end

          begin
            Band.create!(
              id: prod_band["id"],
              name: prod_band["name"],
              website: normalize_website_url(prod_band["website"]),
              created_at: prod_band["created_at"],
              updated_at: prod_band["updated_at"]
            )
            imported_count += 1
            puts "  ✅ Imported band #{prod_band['id']}: #{prod_band['name']}" if imported_count % 25 == 0
          rescue ActiveRecord::RecordInvalid => e
            puts "  ❌ Failed to import band #{prod_band['id']}: #{e.message}"
            skipped_count += 1
          end
        end
      end
    end

    puts "✅ Bands migration complete: #{imported_count} imported, #{skipped_count} skipped"
  end

  desc "Import series from production"
  task import_series: :environment do
    puts "📚 Importing series..."

    production_series = fetch_from_production(<<~SQL)
      SELECT id, name, created_at, updated_at
      FROM series#{' '}
      ORDER BY id
    SQL

    puts "📊 Found #{production_series.length} series in production"

    imported_count = 0
    skipped_count = 0

    production_series.each_slice(50) do |batch|
      Series.transaction do
        batch.each do |prod_series|
          # Skip if series already exists (for resumable migration)
          if Series.exists?(id: prod_series["id"])
            skipped_count += 1
            next
          end

          begin
            Series.create!(
              id: prod_series["id"],
              name: prod_series["name"],
              description: nil,     # Not available in production
              year: 2000,           # Default year for migrated series (required field)
              total_count: nil,     # Not available in production
              created_at: prod_series["created_at"],
              updated_at: prod_series["updated_at"]
            )
            imported_count += 1
            puts "  ✅ Imported series #{prod_series['id']}: #{prod_series['name']}" if imported_count % 25 == 0
          rescue ActiveRecord::RecordInvalid => e
            puts "  ❌ Failed to import series #{prod_series['id']}: #{e.message}"
            skipped_count += 1
          end
        end
      end
    end

    puts "✅ Series migration complete: #{imported_count} imported, #{skipped_count} skipped"
  end

  desc "Import artworks as posters from production"
  task import_posters: :environment do
    puts "🖼️  Importing artworks → posters..."

    production_artworks = fetch_from_production(<<~SQL)
      SELECT a.id, a.name, a.note, a.edition_size, a.release_date,#{' '}
             a.original_price, a.band_id, a.venue_id, a.created_at, a.updated_at,
             array_agg(DISTINCT aa.artist_id) FILTER (WHERE aa.artist_id IS NOT NULL) as artist_ids,
             array_agg(DISTINCT ars.series_id) FILTER (WHERE ars.series_id IS NOT NULL) as series_ids
      FROM artworks a
      LEFT JOIN artists_artworks aa ON a.id = aa.artwork_id
      LEFT JOIN artworks_series ars ON a.id = ars.artwork_id
      GROUP BY a.id, a.name, a.note, a.edition_size, a.release_date,#{' '}
               a.original_price, a.band_id, a.venue_id, a.created_at, a.updated_at
      ORDER BY a.id
    SQL

    puts "📊 Found #{production_artworks.length} artworks in production"

    imported_count = 0
    skipped_count = 0

    production_artworks.each_slice(50) do |batch|
      Poster.transaction do
        batch.each do |prod_artwork|
          # Skip if poster already exists (for resumable migration)
          if Poster.exists?(id: prod_artwork["id"])
            skipped_count += 1
            next
          end

          begin
            poster = Poster.create!(
              id: prod_artwork["id"],
              name: generate_poster_name(prod_artwork),
              description: prod_artwork["note"],
              edition_size: prod_artwork["edition_size"],
              release_date: prod_artwork["release_date"] || Date.current,
              original_price: normalize_price(prod_artwork["original_price"]),
              band_id: prod_artwork["band_id"],
              venue_id: prod_artwork["venue_id"],
              created_at: prod_artwork["created_at"],
              updated_at: prod_artwork["updated_at"]
            )

            # Associate artists and series using Rails associations
            if prod_artwork["artist_ids"]
              artist_ids = parse_pg_array(prod_artwork["artist_ids"]).compact
              poster.artist_ids = artist_ids if artist_ids.any?
            end

            if prod_artwork["series_ids"]
              series_ids = parse_pg_array(prod_artwork["series_ids"]).compact
              poster.series_ids = series_ids if series_ids.any?
            end

            imported_count += 1
            puts "  ✅ Imported poster #{prod_artwork['id']}: #{prod_artwork['name']}" if imported_count % 50 == 0
          rescue ActiveRecord::RecordInvalid => e
            puts "  ❌ Failed to import poster #{prod_artwork['id']}: #{e.message}"
            skipped_count += 1
          end
        end
      end
    end

    puts "✅ Posters migration complete: #{imported_count} imported, #{skipped_count} skipped"
  end

  desc "Import user collections (user_artworks → user_posters)"
  task import_user_collections: :environment do
    puts "📦 Importing user collections..."

    puts "📝 User Collections migration mapping:"
    puts "  Production user_artworks.user_id → user_posters.user_id"
    puts "  Production user_artworks.artwork_id → user_posters.poster_id"
    puts "  Production user_artworks.purchased_on → user_posters.purchase_date"
    puts "  Production user_artworks.purchase_price → user_posters.purchase_price (keep as integer cents)"
    puts "  Production user_artworks.edition_number → user_posters.edition_number"
    puts "  Production user_artworks.condition → user_posters.condition"
    puts "  Production user_artworks.notes → user_posters.notes"
    puts "  Production user_artworks.edition_type → user_posters.edition_type"
    puts "  All status = 'owned' (original app only tracked owned collections, no want lists)"

    puts "📋 Edition type enum values:"
    puts "  AE - Artist Edition, AP - Artist Proof, MP - Misprint"
    puts "  OG - Original Artwork, SE - Show Edition, TS - Test Print, OT - Other"

    # Store original connection and connect to production
    original_config = ActiveRecord::Base.connection_db_config
    prod_conn = establish_production_connection

    # Get user collections data
    puts "📋 Fetching user collections from production backup..."
    collections = prod_conn.exec_query('
      SELECT * FROM user_artworks
      ORDER BY user_id, artwork_id
    ')

    # Restore development database connection
    ActiveRecord::Base.establish_connection(original_config)

    puts "📊 Found #{collections.length} user collections to process"

    # Track migration progress
    successful_migrations = 0
    failed_migrations = 0
    missing_users = 0
    missing_posters = 0

    collections.each_with_index do |collection, index|
      # Progress indicator
      if (index + 1) % 50 == 0 || index == 0
        puts "📈 Processing collection #{index + 1}/#{collections.length} (#{((index + 1) * 100.0 / collections.length).round(1)}%)"
      end

      begin
        # Verify user exists in new system
        user = User.find_by(id: collection["user_id"])
        unless user
          puts "⚠️  User not found for user_id #{collection['user_id']}, skipping" if index < 10
          missing_users += 1
          next
        end

        # Verify poster exists in new system
        poster = Poster.find_by(id: collection["artwork_id"])
        unless poster
          puts "⚠️  Poster not found for artwork_id #{collection['artwork_id']}, skipping" if index < 10
          missing_posters += 1
          next
        end

        # All records from production are owned items (original app didn't have want lists)
        status = "owned"

        # Create user poster record
        user_poster = UserPoster.create!(
          user: user,
          poster: poster,
          status: status,
          purchase_date: collection["purchased_on"],
          purchase_price: normalize_price(collection["purchase_price"]),
          edition_number: collection["edition_number"].present? ? collection["edition_number"] : nil,
          condition: normalize_condition(collection["condition"]),
          notes: collection["notes"].present? ? collection["notes"] : nil,
          edition_type: normalize_edition_type(collection["edition_type"]),
          created_at: collection["created_at"],
          updated_at: collection["updated_at"]
        )

        successful_migrations += 1

        if index < 10  # Show first 10 for verification
          puts "✅ Created #{status} collection: #{user.email} → #{poster.name}"
        end

      rescue => e
        puts "❌ Error creating collection for user #{collection['user_id']}, artwork #{collection['artwork_id']}: #{e.message}"
        failed_migrations += 1
        next
      end
    end

    # Final statistics
    puts "\n📊 User Collections Migration Complete!"
    puts "✅ Successful: #{successful_migrations}"
    puts "❌ Failed: #{failed_migrations}"
    puts "👤 Missing users: #{missing_users}"
    puts "📋 Missing posters: #{missing_posters}"
    puts "📈 Success rate: #{(successful_migrations * 100.0 / collections.length).round(1)}%"

    # Verify collections by status
    puts "\n📊 Collection Status Breakdown:"
    puts "🏠 Owned: #{UserPoster.owned.count}"
    puts "💝 Wanted: #{UserPoster.wanted.count}"
    puts "👀 Watching: #{UserPoster.watching.count}"
    puts "📦 Total: #{UserPoster.count}"

    puts "\n🎯 User Collections Migration Complete!"
  end

  desc "Export image metadata from production for ActiveStorage migration"
  task export_image_metadata: :environment do
    puts "📸 Exporting production image metadata..."

    puts "📝 Image export strategy:"
    puts "  1. Export artwork images (active_storage_attachments where record_type = 'Artwork')"
    puts "  2. Export transaction images (active_storage_attachments where record_type = 'Transaction')"
    puts "  3. Include: record_id, blob_id, filename, key, content_type, byte_size"
    puts "  4. Generate CSV files for image reattachment process"

    export_dir = Rails.root.join("migration", "image_exports")
    FileUtils.mkdir_p(export_dir)

    puts "📁 Export directory: #{export_dir}"

    # Sample export queries (will need production database connection):
    artwork_images_csv = export_dir.join("artwork_images.csv")
    transaction_images_csv = export_dir.join("transaction_images.csv")

    puts "📄 Will generate:"
    puts "  - #{artwork_images_csv} (artwork → poster images)"
    puts "  - #{transaction_images_csv} (transaction → external_sale images)"

    # Sample structure:
    # artwork_images = fetch_from_production(<<~SQL)
    #   SELECT
    #     att.record_id as artwork_id,
    #     att.name as attachment_name,
    #     blob.key as s3_key,
    #     blob.filename,
    #     blob.content_type,
    #     blob.byte_size,
    #     blob.checksum
    #   FROM active_storage_attachments att
    #   JOIN active_storage_blobs blob ON att.blob_id = blob.id
    #   WHERE att.record_type = 'Artwork'
    #   ORDER BY att.record_id
    # SQL
    #
    # CSV.open(artwork_images_csv, 'w', write_headers: true,
    #          headers: %w[artwork_id attachment_name s3_key filename content_type byte_size checksum]) do |csv|
    #   artwork_images.each { |row| csv << row.values }
    # end

    puts "⏭️  Image metadata export prepared (awaiting production database connection)"
  end

  desc "Reattach images using ActiveStorage from exported metadata"
  task reattach_images: :environment do
    puts "🔗 Reattaching images via ActiveStorage..."

    puts "📝 Image reattachment strategy:"
    puts "  1. Read exported CSV files"
    puts "  2. For each image, find corresponding new record (artwork_id → poster_id)"
    puts "  3. Load from local downloaded files and reattach via ActiveStorage"
    puts "  4. ActiveStorage handles new blob creation and S3 upload"

    export_dir = Rails.root.join("migration", "image_exports")
    images_dir = Rails.root.join("migration", "images")

    puts "📁 Reading exports from: #{export_dir}"
    puts "🖼️  Using local images from: #{images_dir}"

    # Process artwork images first
    artwork_images_csv = export_dir.join("artwork_images.csv")
    if File.exist?(artwork_images_csv)
      puts "\n🖼️  Processing artwork images..."

      CSV.foreach(artwork_images_csv, headers: true).with_index(1) do |row, index|
        puts "  Processing #{index}: #{row['filename']}" if index % 10 == 0

        # Sample reattachment logic:
        # artwork_id = row['artwork_id']
        # poster = Poster.find_by(id: artwork_id)
        #
        # if poster
        #   local_image_path = images_dir.join(row['s3_key'])
        #
        #   if File.exist?(local_image_path)
        #     begin
        #       poster.image.attach(
        #         io: File.open(local_image_path),
        #         filename: row['filename'],
        #         content_type: row['content_type']
        #       )
        #       puts "    ✅ Attached #{row['filename']} to poster #{poster.id}"
        #     rescue => e
        #       puts "    ❌ Failed to attach #{row['filename']}: #{e.message}"
        #     end
        #   else
        #     puts "    ⚠️  Image file not found: #{local_image_path}"
        #   end
        # else
        #   puts "    ⚠️  Poster not found for artwork_id #{artwork_id}"
        # end
      end
    else
      puts "❌ Artwork images CSV not found: #{artwork_images_csv}"
    end

    # Process transaction images (future: when ExternalSale model exists)
    puts "\n📊 Transaction images will be processed in Phase 3 (External Sales feature)"

    puts "⏭️  Image reattachment prepared (requires exported CSV files and S3 access)"
  end

  desc "Validate migration results"
  task validate_migration: :environment do
    puts "✅ Validating migration results..."

    puts "\n📊 Record Count Validation:"
    puts "  Users: #{User.count} (expected ~750)"
    puts "  Venues: #{Venue.count}"
    puts "  Artists: #{Artist.count}"
    puts "  Bands: #{Band.count}"
    puts "  Series: #{Series.count}"
    puts "  Posters: #{Poster.count} (expected 773)"
    puts "  User Collections: #{UserPoster.count} (expected ~500)"
    puts "  Images: #{ActiveStorage::Attachment.count} (expected ~968 artwork images)"

    puts "\n🔗 Association Validation:"
    posters_without_band = Poster.where(band_id: nil).count
    posters_without_venue = Poster.where(venue_id: nil).count
    puts "  Posters without band: #{posters_without_band}"
    puts "  Posters without venue: #{posters_without_venue}"

    puts "\n🖼️  Image Attachment Validation:"
    posters_with_images = Poster.joins(:image_attachment).distinct.count
    puts "  Posters with images: #{posters_with_images}"

    puts "\n💰 Price Data Validation:"
    posters_with_price = Poster.where.not(original_price: nil).count
    puts "  Posters with original price: #{posters_with_price}"

    collections_with_price = UserPoster.where.not(purchase_price: nil).count
    puts "  Collections with purchase price: #{collections_with_price}"

    puts "\n🎯 Data Integrity Checks:"
    orphaned_collections = UserPoster.left_joins(:user, :poster)
                                    .where(users: { id: nil })
                                    .or(UserPoster.left_joins(:user, :poster).where(posters: { id: nil }))
                                    .count
    puts "  Orphaned user collections: #{orphaned_collections} (should be 0)"

    puts "\n✅ Migration validation complete!"
  end

  desc "Clean up temporary migration data"
  task cleanup_temp_data: :environment do
    puts "🧹 Cleaning up temporary migration data..."

    temp_dirs = [
      Rails.root.join("migration", "image_exports"),
      Rails.root.join("tmp", "migration")
    ]

    temp_dirs.each do |dir|
      if Dir.exist?(dir)
        FileUtils.rm_rf(dir)
        puts "  🗑️  Removed #{dir}"
      end
    end

    puts "✅ Cleanup complete!"
  end

  desc "Reset terms acceptance for imported users to force re-acceptance"
  task reset_terms_acceptance: :environment do
    puts "📋 Resetting terms acceptance for imported users..."

    # Find all users with legacy import terms version
    legacy_users = User.where(terms_version: "legacy-import")
    legacy_count = legacy_users.count

    puts "📊 Found #{legacy_count} users with legacy terms version"

    if legacy_count == 0
      puts "⚠️  No legacy users found. Terms reset not needed."
      return
    end

    # Confirm this action
    puts "⚠️  This will clear terms acceptance for #{legacy_count} users."
    puts "   Users will be prompted to accept current terms on next login."
    puts "   Continue? (y/N)"

    unless Rails.env.production? || ENV["FORCE_RESET"] == "true"
      # In development/test, proceed automatically
      puts "   (Auto-proceeding in non-production environment)"
    else
      # In production, require confirmation
      response = STDIN.gets.chomp.downcase
      unless response == "y" || response == "yes"
        puts "❌ Terms reset cancelled."
        return
      end
    end

    # Reset terms acceptance for legacy users
    reset_count = 0
    legacy_users.find_each do |user|
      user.update!(
        terms_accepted_at: nil,
        terms_version: nil
      )
      reset_count += 1
      puts "  ✅ Reset terms for user #{user.id}: #{user.email}" if reset_count % 100 == 0
    end

    puts "✅ Terms reset complete: #{reset_count} users will be prompted to accept current terms"
    puts "📋 Current terms version: #{Rails.application.config.authentication[:current_terms_version]}"
  end

  private

  # Helper method to map ActiveStorage blob key to S3 source path
  def map_blob_key_to_s3_path(blob_key)
    # ActiveStorage keys are typically like: 2a/x7/2ax7abc123def456...
    # For migration source bucket, we'll use the same key structure
    # This can be customized based on how images are organized in the source bucket

    # Option 1: Use the blob key directly (if source bucket mirrors ActiveStorage structure)
    blob_key

    # Option 2: Add a prefix if images are organized differently
    # "images/#{blob_key}"

    # Option 3: Custom mapping based on your source bucket organization
    # You may need to adjust this based on how the source bucket is structured
  end

  # Helper method to normalize price values (dollars to cents)
  def normalize_price(price_value)
    return nil if price_value.blank?

    case price_value
    when String
      # Handle dollar amounts like "$25.00" or "25.00"
      cleaned = price_value.gsub(/[$,]/, "")
      (cleaned.to_f * 100).to_i
    when Integer, Float
      # Production data stores prices as dollars, convert to cents
      (price_value.to_f * 100).to_i
    else
      nil
    end
  end

  # Helper method to determine venue type from production data
  def determine_venue_type(prod_venue)
    # Logic to map old venue data to new enum
    # Default to 'other' if can't determine
    "other"
  end

  # Helper method to normalize website URLs
  def normalize_website_url(url)
    return nil if url.blank?

    # If URL already has protocol, return as-is
    return url if url.match?(/\Ahttps?:\/\//)

    # Add http:// prefix to URLs without protocol
    "http://#{url}"
  end

  # Helper method to parse PostgreSQL array format like "{1,2,3}"
  def parse_pg_array(pg_array_string)
    return [] if pg_array_string.blank? || pg_array_string == "{}"

    # Remove curly braces and split by comma
    pg_array_string.gsub(/[{}]/, "").split(",").map(&:strip).map(&:to_i)
  end

  # Helper method to normalize edition types from production data
  def normalize_edition_type(edition_type_string)
    return nil if edition_type_string.blank?

    # Extract the abbreviation from strings like "SE - Show Edition"
    if edition_type_string.include?(" - ")
      abbreviation = edition_type_string.split(" - ").first.strip
      return abbreviation if %w[AE AP MP OG SE TS OT].include?(abbreviation)
    end

    # Return as-is if it's already a valid abbreviation
    return edition_type_string if %w[AE AP MP OG SE TS OT].include?(edition_type_string)

    # Default to "OT" (Other) for unrecognized values
    "OT"
  end

  # Helper method to normalize condition values from production data
  def normalize_condition(condition_string)
    return nil if condition_string.blank?

    # Normalize common condition strings to enum values
    case condition_string.downcase.strip
    when "mint"
      "mint"
    when "near mint", "near_mint"
      "near_mint"
    when "very fine", "very_fine"
      "very_fine"
    when "fine"
      "fine"
    when "very good", "very_good"
      "very_good"
    when "good"
      "good"
    when "fair"
      "fair"
    when "poor"
      "poor"
    else
      # Default to nil for unrecognized values
      nil
    end
  end

  # Helper method to generate poster names when missing
  def generate_poster_name(prod_artwork)
    # Use existing name if present and not blank
    return prod_artwork["name"] if prod_artwork["name"].present?

    # Generate name from event details
    parts = []

    # Add band name
    if prod_artwork["band_id"]
      band_name = Band.find_by(id: prod_artwork["band_id"])&.name
      parts << band_name if band_name.present?
    end

    # Add venue name
    if prod_artwork["venue_id"]
      venue_name = Venue.find_by(id: prod_artwork["venue_id"])&.name
      parts << venue_name if venue_name.present?
    end

    # Add year if available
    if prod_artwork["release_date"]
      begin
        year = Date.parse(prod_artwork["release_date"]).year
        parts << year.to_s
      rescue Date::Error
        # Skip invalid dates
      end
    end

    # Fallback to poster ID if no event details
    if parts.empty?
      return "Poster ##{prod_artwork['id']}"
    end

    parts.join(" - ")
  end

  # Production database connection
  def production_db_connection
    @prod_conn ||= PG.connect(
      host: "localhost",
      dbname: "art_exchange_production_backup",
      user: ENV["USER"] || `whoami`.strip
    )
  end

  # ActiveRecord connection to production database
  def establish_production_connection
    ActiveRecord::Base.establish_connection(
      adapter: "postgresql",
      database: "art_exchange_production_backup",
      host: "localhost"
    )
    ActiveRecord::Base.connection
  end

  def fetch_from_production(sql)
    result = production_db_connection.exec(sql)
    result.to_a
  rescue PG::Error => e
    puts "❌ Database error: #{e.message}"
    []
  end
end
