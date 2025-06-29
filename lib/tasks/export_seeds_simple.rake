namespace :dev do
  desc "Export migrated data to seeds format (simple version)"
  task export_to_seeds_simple: :environment do
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

      # Export each model
      [User, Venue, Artist, Band, Series, Poster, UserPoster].each do |model|
        puts "📤 Exporting #{model.count} #{model.name.downcase.pluralize}..."
        
        file.puts "puts '#{model.name.pluralize} creation...'"
        file.puts "#{model.name.downcase}_data = #{model.all.to_a.inspect}"
        file.puts "#{model.name}.create!(#{model.name.downcase}_data)"
        file.puts "puts \"✅ Created \#{#{model.name}.count} #{model.name.downcase.pluralize}\""
        file.puts ""
      end

      # Handle associations
      file.puts "puts '🔗 Creating associations...'"
      
      # Artists-Posters associations
      if ActiveRecord::Base.connection.table_exists?('artists_posters')
        artists_posters = ActiveRecord::Base.connection.execute("SELECT * FROM artists_posters")
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
        end
      end

      # Posters-Series associations  
      if ActiveRecord::Base.connection.table_exists?('posters_series')
        posters_series = ActiveRecord::Base.connection.execute("SELECT * FROM posters_series")
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
        end
      end

      file.puts ""
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