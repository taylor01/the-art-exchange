namespace :dev do
  desc "Export migrated data to seeds format"
  task export_to_seeds: :environment do
    puts "🚀 Exporting migrated data to seeds format..."
    
    seeds_content = []
    seeds_content << "# Production seeds generated from migrated legacy data"
    seeds_content << "# Generated on: #{Time.current}"
    seeds_content << ""
    seeds_content << "puts '🚀 Starting production data seeding...'"
    seeds_content << ""
    seeds_content << "# Check if data already exists"
    seeds_content << "if User.count > 0"
    seeds_content << "  puts '⚠️  Data already exists. Skipping seed.'"
    seeds_content << "  exit"
    seeds_content << "end"
    seeds_content << ""

    # Export Users
    puts "📤 Exporting #{User.count} users..."
    seeds_content << "puts '👥 Creating users...'"
    seeds_content << "users_data = ["
    
    User.find_each.with_index do |user, index|
      user_hash = {
        id: user.id,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        password_digest: user.password_digest,
        confirmed_at: user.confirmed_at,
        confirmation_token: user.confirmation_token,
        confirmation_sent_at: user.confirmation_sent_at,
        otp_secret_key: user.otp_secret_key,
        otp_sent_at: user.otp_sent_at,
        otp_used_at: user.otp_used_at,
        otp_attempts_count: user.otp_attempts_count,
        otp_locked_until: user.otp_locked_until,
        reset_password_token: user.reset_password_token,
        reset_password_sent_at: user.reset_password_sent_at,
        failed_login_attempts: user.failed_login_attempts,
        locked_until: user.locked_until,
        last_login_at: user.last_login_at,
        provider: user.provider,
        uid: user.uid,
        provider_data: user.provider_data,
        admin: user.admin,
        showcase_settings: user.showcase_settings,
        bio: user.bio,
        location: user.location,
        website: user.website,
        phone: user.phone,
        collector_since: user.collector_since,
        preferred_contact_method: user.preferred_contact_method,
        instagram_handle: user.instagram_handle,
        twitter_handle: user.twitter_handle,
        terms_accepted_at: user.terms_accepted_at,
        terms_version: user.terms_version,
        created_at: user.created_at,
        updated_at: user.updated_at
      }
      seeds_content << "  #{user_hash}#{',' if index < User.count - 1}"
    end
    
    seeds_content << "]"
    seeds_content << "User.create!(users_data)"
    seeds_content << "puts \"✅ Created #{User.count} users\""
    seeds_content << ""

    # Export Venues
    puts "📤 Exporting #{Venue.count} venues..."
    seeds_content << "puts '🏛️  Creating venues...'"
    seeds_content << "venues_data = ["
    
    Venue.find_each.with_index do |venue, index|
      venue_hash = {
        id: venue.id,
        name: venue.name,
        city: venue.city,
        state: venue.state,
        country: venue.country,
        latitude: venue.latitude,
        longitude: venue.longitude,
        website: venue.website,
        created_at: venue.created_at,
        updated_at: venue.updated_at
      }
      seeds_content << "  #{venue_hash}#{',' if index < Venue.count - 1}"
    end
    
    seeds_content << "]"
    seeds_content << "Venue.create!(venues_data)"
    seeds_content << "puts \"✅ Created #{Venue.count} venues\""
    seeds_content << ""

    # Export Artists
    puts "📤 Exporting #{Artist.count} artists..."
    seeds_content << "puts '🎨 Creating artists...'"
    seeds_content << "artists_data = ["
    
    Artist.find_each.with_index do |artist, index|
      artist_hash = {
        id: artist.id,
        name: artist.name,
        website: artist.website,
        created_at: artist.created_at.to_s(:db),
        updated_at: artist.updated_at      }
      seeds_content << "  #{artist_hash}#{',' if index < Artist.count - 1}"
    end
    
    seeds_content << "]"
    seeds_content << "Artist.create!(artists_data)"
    seeds_content << "puts \"✅ Created #{Artist.count} artists\""
    seeds_content << ""

    # Export Bands
    puts "📤 Exporting #{Band.count} bands..."
    seeds_content << "puts '🎵 Creating bands...'"
    seeds_content << "bands_data = ["
    
    Band.find_each.with_index do |band, index|
      band_hash = {
        id: band.id,
        name: band.name,
        website: band.website,
        created_at: band.created_at.to_s(:db),
        updated_at: band.updated_at      }
      seeds_content << "  #{band_hash}#{',' if index < Band.count - 1}"
    end
    
    seeds_content << "]"
    seeds_content << "Band.create!(bands_data)"
    seeds_content << "puts \"✅ Created #{Band.count} bands\""
    seeds_content << ""

    # Export Series
    puts "📤 Exporting #{Series.count} series..."
    seeds_content << "puts '📚 Creating series...'"
    seeds_content << "series_data = ["
    
    Series.find_each.with_index do |series, index|
      series_hash = {
        id: series.id,
        name: series.name,
        created_at: series.created_at.to_s(:db),
        updated_at: series.updated_at      }
      seeds_content << "  #{series_hash}#{',' if index < Series.count - 1}"
    end
    
    seeds_content << "]"
    seeds_content << "Series.create!(series_data)"
    seeds_content << "puts \"✅ Created #{Series.count} series\""
    seeds_content << ""

    # Export Posters
    puts "📤 Exporting #{Poster.count} posters..."
    seeds_content << "puts '🖼️  Creating posters...'"
    seeds_content << "posters_data = ["
    
    Poster.find_each.with_index do |poster, index|
      poster_hash = {
        id: poster.id,
        name: poster.name,
        band_id: poster.band_id,
        venue_id: poster.venue_id,
        release_date: poster.release_date&.to_s(:db),
        edition_size: poster.edition_size,
        original_price: poster.original_price,
        description: poster.description,
        created_at: poster.created_at.to_s(:db),
        updated_at: poster.updated_at      }
      seeds_content << "  #{poster_hash}#{',' if index < Poster.count - 1}"
    end
    
    seeds_content << "]"
    seeds_content << "Poster.create!(posters_data)"
    seeds_content << "puts \"✅ Created #{Poster.count} posters\""
    seeds_content << ""

    # Export UserPosters
    puts "📤 Exporting #{UserPoster.count} user collections..."
    seeds_content << "puts '📦 Creating user collections...'"
    seeds_content << "user_posters_data = ["
    
    UserPoster.find_each.with_index do |user_poster, index|
      user_poster_hash = {
        user_id: user_poster.user_id,
        poster_id: user_poster.poster_id,
        status: user_poster.status,
        purchase_date: user_poster.purchase_date&.to_s(:db),
        purchase_price: user_poster.purchase_price,
        edition_number: user_poster.edition_number,
        condition: user_poster.condition,
        notes: user_poster.notes,
        edition_type: user_poster.edition_type,
        created_at: user_poster.created_at.to_s(:db),
        updated_at: user_poster.updated_at      }
      seeds_content << "  #{user_poster_hash}#{',' if index < UserPoster.count - 1}"
    end
    
    seeds_content << "]"
    seeds_content << "UserPoster.create!(user_posters_data)"
    seeds_content << "puts \"✅ Created #{UserPoster.count} user collections\""
    seeds_content << ""

    # Handle associations
    seeds_content << "puts '🔗 Creating associations...'"
    
    # Artists-Posters associations
    if ActiveRecord::Base.connection.table_exists?('artists_posters')
      artists_posters_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM artists_posters").first['count'].to_i
      if artists_posters_count > 0
        puts "📤 Exporting #{artists_posters_count} artist-poster associations..."
        seeds_content << "# Artist-Poster associations"
        ActiveRecord::Base.connection.execute("SELECT * FROM artists_posters").each do |assoc|
          seeds_content << "Poster.find(#{assoc['poster_id']}).artists << Artist.find(#{assoc['artist_id']}) unless Poster.find(#{assoc['poster_id']}).artists.include?(Artist.find(#{assoc['artist_id']}))"
        end
      end
    end

    # Posters-Series associations  
    if ActiveRecord::Base.connection.table_exists?('posters_series')
      posters_series_count = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM posters_series").first['count'].to_i
      if posters_series_count > 0
        puts "📤 Exporting #{posters_series_count} poster-series associations..."
        seeds_content << "# Poster-Series associations"
        ActiveRecord::Base.connection.execute("SELECT * FROM posters_series").each do |assoc|
          seeds_content << "Poster.find(#{assoc['poster_id']}).series << Series.find(#{assoc['series_id']}) unless Poster.find(#{assoc['poster_id']}).series.include?(Series.find(#{assoc['series_id']}))"
        end
      end
    end

    seeds_content << ""
    seeds_content << "puts '🎯 Production data seeding complete!'"
    seeds_content << "puts \"📊 Final counts:\""
    seeds_content << "puts \"  Users: \#{User.count}\""
    seeds_content << "puts \"  Venues: \#{Venue.count}\""
    seeds_content << "puts \"  Artists: \#{Artist.count}\""
    seeds_content << "puts \"  Bands: \#{Band.count}\""
    seeds_content << "puts \"  Series: \#{Series.count}\""
    seeds_content << "puts \"  Posters: \#{Poster.count}\""
    seeds_content << "puts \"  User Collections: \#{UserPoster.count}\""

    # Write to seeds file
    File.write('db/seeds.rb', seeds_content.join("\n"))
    
    puts "✅ Seeds file generated: db/seeds.rb"
    puts "📊 Export summary:"
    puts "  Users: #{User.count}"
    puts "  Venues: #{Venue.count}"
    puts "  Artists: #{Artist.count}"
    puts "  Bands: #{Band.count}"
    puts "  Series: #{Series.count}"
    puts "  Posters: #{Poster.count}"
    puts "  User Collections: #{UserPoster.count}"
    puts ""
    puts "🚀 Ready to deploy and run: bin/rails db:seed"
  end
end