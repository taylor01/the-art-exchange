# frozen_string_literal: true

namespace :migrate do
  desc "Migrate poster images using extracted blob mappings (Production)"
  task migrate_production_images: :environment do
    puts "🖼️ Starting Production Image Migration from S3 Source"

    # Load blob mappings
    mappings_file = Rails.root.join("db", "poster_blob_mappings.json")
    unless File.exist?(mappings_file)
      abort("❌ Mappings file not found: #{mappings_file}")
    end

    mappings = JSON.parse(File.read(mappings_file))
    puts "📊 Loaded #{mappings.length} image mappings"

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

    # Track migration progress
    successful_migrations = 0
    failed_migrations = 0
    missing_files = 0
    missing_posters = 0
    already_attached = 0

    mappings.each_with_index do |mapping, index|
      poster_id = mapping["poster_id"]
      blob_key = mapping["blob_key"]
      filename = mapping["filename"]
      content_type = mapping["content_type"]
      byte_size = mapping["byte_size"]

      # Progress indicator
      if (index + 1) % 50 == 0 || index == 0
        puts "📈 Processing image #{index + 1}/#{mappings.length} (#{((index + 1) * 100.0 / mappings.length).round(1)}%)"
      end

      begin
        # Find corresponding poster in production system
        poster = Poster.find_by(id: poster_id)
        unless poster
          puts "⚠️  Poster not found for id #{poster_id}, skipping" if index < 10
          missing_posters += 1
          next
        end

        # Skip if poster already has an image attached
        if poster.image.attached?
          already_attached += 1
          next
        end

        # Use blob key directly as S3 key
        s3_key = blob_key

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
            puts "✅ Attached #{filename} to poster #{poster.id} (#{poster.name})" if index < 10
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
        puts "❌ Error processing image for poster #{poster_id}: #{e.message}"
        failed_migrations += 1
        next
      end
    end

    # Final statistics
    puts "\n📊 Production Image Migration Complete!"
    puts "✅ Successful: #{successful_migrations}"
    puts "🔄 Already attached: #{already_attached}"
    puts "❌ Failed: #{failed_migrations}"
    puts "📁 Missing S3 objects: #{missing_files}"
    puts "📋 Missing posters: #{missing_posters}"
    puts "📈 Success rate: #{(successful_migrations * 100.0 / (mappings.length - already_attached)).round(1)}%" if (mappings.length - already_attached) > 0

    # Verify total attachments
    total_attached = Poster.joins(:image_attachment).count
    puts "🔗 Total posters with images: #{total_attached}/#{Poster.count}"

    puts "\n🎯 Production Image Migration Complete!"
  end

  desc "Test production image migration with small batch"
  task test_production_image_migration: :environment do
    puts "🧪 Testing Production Image Migration (first 5 mappings)"

    # Load blob mappings (limit to first 5 for testing)
    mappings_file = Rails.root.join("db", "poster_blob_mappings.json")
    unless File.exist?(mappings_file)
      abort("❌ Mappings file not found: #{mappings_file}")
    end

    all_mappings = JSON.parse(File.read(mappings_file))
    mappings = all_mappings.first(5)
    puts "📊 Testing with #{mappings.length} mappings (of #{all_mappings.length} total)"

    # Use same migration logic as main task
    Rake::Task["migrate:migrate_production_images"].reenable
    
    # Temporarily replace the mappings file with test subset
    test_mappings_file = Rails.root.join("db", "test_poster_blob_mappings.json")
    File.write(test_mappings_file, JSON.pretty_generate(mappings))
    
    # Backup original and use test file
    original_file = mappings_file.to_s
    test_file = test_mappings_file.to_s
    
    begin
      FileUtils.mv(original_file, "#{original_file}.backup")
      FileUtils.mv(test_file, original_file)
      
      # Run the migration
      Rake::Task["migrate:migrate_production_images"].invoke
    ensure
      # Restore original file
      FileUtils.mv(original_file, test_file) if File.exist?(original_file)
      FileUtils.mv("#{original_file}.backup", original_file) if File.exist?("#{original_file}.backup")
      File.delete(test_file) if File.exist?(test_file)
    end

    puts "\n🧪 Test Migration Complete!"
  end
end
