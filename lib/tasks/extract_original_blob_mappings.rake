# frozen_string_literal: true

namespace :migrate do
  desc "Extract ORIGINAL blob key mappings from legacy database backup"
  task extract_original_blob_mappings: :environment do
    puts "🔍 Extracting ORIGINAL blob key mappings from legacy database backup..."

    # Store original connection
    original_config = ActiveRecord::Base.connection_db_config

    # Connect to production backup database temporarily
    prod_conn = establish_production_connection

    # Get artwork to blob mapping from ORIGINAL database
    puts "📋 Fetching ORIGINAL image mappings from production backup..."
    mappings = prod_conn.exec_query('
      SELECT a.record_id as artwork_id, b.key, b.filename, b.content_type, b.byte_size
      FROM active_storage_attachments a
      JOIN active_storage_blobs b ON a.blob_id = b.id
      WHERE a.record_type = \'Artwork\' AND a.name = \'image\'
      ORDER BY a.record_id
    ')

    # Restore development database connection
    ActiveRecord::Base.establish_connection(original_config)

    puts "📊 Found #{mappings.length} ORIGINAL image mappings to process"

    # Generate mappings hash with original blob keys
    mappings_hash = mappings.map do |mapping|
      artwork_id = mapping["artwork_id"]  # Use the alias from the SQL query
      
      # Find corresponding poster in current system
      poster = Poster.find_by(id: artwork_id)
      
      {
        poster_id: artwork_id,
        poster_name: poster&.name || "Poster ##{artwork_id}",
        original_blob_key: mapping["key"],  # This is the ORIGINAL blob key from legacy system
        filename: mapping["filename"],
        content_type: mapping["content_type"],
        byte_size: mapping["byte_size"]
      }
    end

    # Write to JSON file for production use
    json_output_path = Rails.root.join("db", "original_poster_blob_mappings.json")
    File.write(json_output_path, JSON.pretty_generate(mappings_hash))
    puts "✅ ORIGINAL JSON mappings written to: #{json_output_path}"

    # Write to Ruby file for seed integration
    ruby_output_path = Rails.root.join("db", "original_poster_blob_mappings.rb")
    File.write(ruby_output_path, generate_ruby_mappings(mappings_hash))
    puts "✅ ORIGINAL Ruby mappings written to: #{ruby_output_path}"

    # Update the production migration task to use original blob keys
    migration_task_path = Rails.root.join("lib", "tasks", "production_image_migration.rake")
    File.write(migration_task_path, generate_production_migration_task)
    puts "✅ Updated production migration task written to: #{migration_task_path}"

    puts "\n📋 Summary:"
    puts "   Posters with ORIGINAL blob mappings: #{mappings_hash.length}"
    puts "   Total file size: #{(mappings_hash.sum { |m| m[:byte_size].to_i } / 1024.0 / 1024.0).round(2)} MB"
    puts "\n🚀 ORIGINAL blob mappings ready for production deployment!"
  end

  private

  def generate_ruby_mappings(mappings_hash)
    <<~RUBY
      # frozen_string_literal: true
      # Generated automatically from ORIGINAL legacy database backup
      # Contains poster-to-ORIGINAL-blob mappings for production image migration

      ORIGINAL_POSTER_BLOB_MAPPINGS = #{mappings_hash.inspect}.freeze
    RUBY
  end

  def generate_production_migration_task
    <<~RUBY
      # frozen_string_literal: true

      namespace :migrate do
        desc "Migrate poster images using ORIGINAL blob mappings (Production)"
        task migrate_production_images: :environment do
          puts "🖼️ Starting Production Image Migration from S3 Source (using ORIGINAL blob keys)"

          # Load ORIGINAL blob mappings
          mappings_file = Rails.root.join("db", "original_poster_blob_mappings.json")
          unless File.exist?(mappings_file)
            abort("❌ ORIGINAL mappings file not found: \#{mappings_file}")
          end

          mappings = JSON.parse(File.read(mappings_file))
          puts "📊 Loaded \#{mappings.length} ORIGINAL image mappings"

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
          puts "   Bucket: \#{source_bucket}"
          puts "   Region: \#{source_region}"

          # Initialize S3 client for source bucket
          require "aws-sdk-s3"
          s3_client = Aws::S3::Client.new(
            access_key_id: ENV["AWS_ACCESS_KEY_ID"],
            secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
            region: source_region
          )

          # Track migration progress
          successful_migrations = 0
          failed_migrations = 0
          missing_files = 0
          missing_posters = 0
          already_attached = 0

          mappings.each_with_index do |mapping, index|
            poster_id = mapping["poster_id"]
            original_blob_key = mapping["original_blob_key"]  # Use ORIGINAL blob key
            filename = mapping["filename"]
            content_type = mapping["content_type"]
            byte_size = mapping["byte_size"]

            # Progress indicator
            if (index + 1) % 50 == 0 || index == 0
              puts "📈 Processing image \#{index + 1}/\#{mappings.length} (\#{((index + 1) * 100.0 / mappings.length).round(1)}%)"
            end

            begin
              # Find corresponding poster in production system
              poster = Poster.find_by(id: poster_id)
              unless poster
                puts "⚠️  Poster not found for id \#{poster_id}, skipping" if index < 10
                missing_posters += 1
                next
              end

              # Skip if poster already has an image attached
              if poster.image.attached?
                already_attached += 1
                next
              end

              # Use ORIGINAL blob key directly as S3 key
              s3_key = original_blob_key

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
                  puts "✅ Attached \#{filename} to poster \#{poster.id} (\#{poster.name})" if index < 10
                else
                  puts "❌ Failed to attach image to poster \#{poster.id}"
                  failed_migrations += 1
                end

              rescue Aws::S3::Errors::NoSuchKey
                puts "⚠️  S3 object not found: \#{s3_key}, skipping poster \#{poster.id}" if index < 10
                missing_files += 1
                next
              rescue Aws::S3::Errors::ServiceError => e
                puts "❌ S3 error for \#{s3_key}: \#{e.message}"
                failed_migrations += 1
                next
              end

            rescue => e
              puts "❌ Error processing image for poster \#{poster_id}: \#{e.message}"
              failed_migrations += 1
              next
            end
          end

          # Final statistics
          puts "\\n📊 Production Image Migration Complete!"
          puts "✅ Successful: \#{successful_migrations}"
          puts "🔄 Already attached: \#{already_attached}"
          puts "❌ Failed: \#{failed_migrations}"
          puts "📁 Missing S3 objects: \#{missing_files}"
          puts "📋 Missing posters: \#{missing_posters}"
          puts "📈 Success rate: \#{(successful_migrations * 100.0 / (mappings.length - already_attached)).round(1)}%" if (mappings.length - already_attached) > 0

          # Verify total attachments
          total_attached = Poster.joins(:image_attachment).count
          puts "🔗 Total posters with images: \#{total_attached}/\#{Poster.count}"

          puts "\\n🎯 Production Image Migration Complete!"
        end

        desc "Test production image migration with small batch (ORIGINAL blob keys)"
        task test_production_image_migration: :environment do
          puts "🧪 Testing Production Image Migration (first 5 ORIGINAL mappings)"

          # Load ORIGINAL blob mappings (limit to first 5 for testing)
          mappings_file = Rails.root.join("db", "original_poster_blob_mappings.json")
          unless File.exist?(mappings_file)
            abort("❌ ORIGINAL mappings file not found: \#{mappings_file}")
          end

          all_mappings = JSON.parse(File.read(mappings_file))
          mappings = all_mappings.first(5)
          puts "📊 Testing with \#{mappings.length} ORIGINAL mappings (of \#{all_mappings.length} total)"

          # Use same migration logic as main task
          Rake::Task["migrate:migrate_production_images"].reenable
          
          # Temporarily replace the mappings file with test subset
          test_mappings_file = Rails.root.join("db", "test_original_poster_blob_mappings.json")
          File.write(test_mappings_file, JSON.pretty_generate(mappings))
          
          # Backup original and use test file
          original_file = mappings_file.to_s
          test_file = test_mappings_file.to_s
          
          begin
            FileUtils.mv(original_file, "\#{original_file}.backup")
            FileUtils.mv(test_file, original_file)
            
            # Run the migration
            Rake::Task["migrate:migrate_production_images"].invoke
          ensure
            # Restore original file
            FileUtils.mv(original_file, test_file) if File.exist?(original_file)
            FileUtils.mv("\#{original_file}.backup", original_file) if File.exist?("\#{original_file}.backup")
            File.delete(test_file) if File.exist?(test_file)
          end

          puts "\\n🧪 Test Migration Complete!"
        end
      end
    RUBY
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
end