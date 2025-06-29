namespace :dev do
  desc "Export migrated data to seeds format using JSON"
  task export_to_seeds_json: :environment do
    puts "🚀 Exporting migrated data to seeds format..."
    
    File.open('db/seeds.rb', 'w') do |file|
      file.puts "# Production seeds generated from migrated legacy data"
      file.puts "# Generated on: #{Time.current}"
      file.puts ""
      file.puts "puts '🚀 Starting production data seeding...'"
      file.puts ""
      file.puts "# Check if data already exists"
      file.puts "if User.count > 0"
      file.puts "  puts '⚠️  Data already exists. Skipping seed.'"
      file.puts "  exit"
      file.puts "end"
      file.puts ""

      # Export Users
      puts "📤 Exporting #{User.count} users..."
      user_attributes = User.all.map(&:attributes)
      file.puts "puts '👥 Creating users...'"
      file.puts "user_data = #{user_attributes.to_s}"
      file.puts "User.create!(user_data)"
      file.puts "puts \"✅ Created \#{User.count} users\""
      file.puts ""

      # Export Venues
      puts "📤 Exporting #{Venue.count} venues..."
      venue_attributes = Venue.all.map(&:attributes)
      file.puts "puts '🏛️  Creating venues...'"
      file.puts "venue_data = #{venue_attributes.to_s}"
      file.puts "Venue.create!(venue_data)"
      file.puts "puts \"✅ Created \#{Venue.count} venues\""
      file.puts ""

      # Export Artists
      puts "📤 Exporting #{Artist.count} artists..."
      artist_attributes = Artist.all.map(&:attributes)
      file.puts "puts '🎨 Creating artists...'"
      file.puts "artist_data = #{artist_attributes.to_s}"
      file.puts "Artist.create!(artist_data)"
      file.puts "puts \"✅ Created \#{Artist.count} artists\""
      file.puts ""

      # Export Bands
      puts "📤 Exporting #{Band.count} bands..."
      band_attributes = Band.all.map(&:attributes)
      file.puts "puts '🎵 Creating bands...'"
      file.puts "band_data = #{band_attributes.to_s}"
      file.puts "Band.create!(band_data)"
      file.puts "puts \"✅ Created \#{Band.count} bands\""
      file.puts ""

      # Export Series
      puts "📤 Exporting #{Series.count} series..."
      series_attributes = Series.all.map(&:attributes)
      file.puts "puts '📚 Creating series...'"
      file.puts "series_data = #{series_attributes.to_s}"
      file.puts "Series.create!(series_data)"
      file.puts "puts \"✅ Created \#{Series.count} series\""
      file.puts ""

      # Export Posters
      puts "📤 Exporting #{Poster.count} posters..."
      poster_attributes = Poster.all.map(&:attributes)
      file.puts "puts '🖼️  Creating posters...'"
      file.puts "poster_data = #{poster_attributes.to_s}"
      file.puts "Poster.create!(poster_data)"
      file.puts "puts \"✅ Created \#{Poster.count} posters\""
      file.puts ""

      # Export UserPosters
      puts "📤 Exporting #{UserPoster.count} user collections..."
      user_poster_attributes = UserPoster.all.map(&:attributes)
      file.puts "puts '📦 Creating user collections...'"
      file.puts "user_poster_data = #{user_poster_attributes.to_s}"
      file.puts "UserPoster.create!(user_poster_data)"
      file.puts "puts \"✅ Created \#{UserPoster.count} user collections\""
      file.puts ""

      # Handle associations
      file.puts "puts '🔗 Creating associations...'"
      
      # Artists-Posters associations
      if ActiveRecord::Base.connection.table_exists?('artists_posters')
        artists_posters = ActiveRecord::Base.connection.execute("SELECT * FROM artists_posters").to_a
        if artists_posters.any?
          file.puts "# Artist-Poster associations"
          artists_posters.each do |assoc|
            file.puts "begin"
            file.puts "  poster = Poster.find(#{assoc['poster_id']})"
            file.puts "  artist = Artist.find(#{assoc['artist_id']})"
            file.puts "  poster.artists << artist unless poster.artists.include?(artist)"
            file.puts "rescue => e"
            file.puts "  puts \"Warning: Could not create artist-poster association: \#{e.message}\""
            file.puts "end"
          end
          file.puts ""
        end
      end

      # Posters-Series associations  
      if ActiveRecord::Base.connection.table_exists?('posters_series')
        posters_series = ActiveRecord::Base.connection.execute("SELECT * FROM posters_series").to_a
        if posters_series.any?
          file.puts "# Poster-Series associations"
          posters_series.each do |assoc|
            file.puts "begin"
            file.puts "  poster = Poster.find(#{assoc['poster_id']})"
            file.puts "  series = Series.find(#{assoc['series_id']})"
            file.puts "  poster.series << series unless poster.series.include?(series)"
            file.puts "rescue => e"
            file.puts "  puts \"Warning: Could not create poster-series association: \#{e.message}\""
            file.puts "end"
          end
          file.puts ""
        end
      end

      file.puts "puts '🎯 Production data seeding complete!'"
      file.puts "puts \"📊 Final counts:\""
      file.puts "puts \"  Users: \#{User.count}\""
      file.puts "puts \"  Venues: \#{Venue.count}\""
      file.puts "puts \"  Artists: \#{Artist.count}\""
      file.puts "puts \"  Bands: \#{Band.count}\""
      file.puts "puts \"  Series: \#{Series.count}\""
      file.puts "puts \"  Posters: \#{Poster.count}\""
      file.puts "puts \"  User Collections: \#{UserPoster.count}\""
    end
    
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