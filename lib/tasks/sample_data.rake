namespace :sample_data do
  desc "Create sample posters and collections for development"
  task create: :environment do
    puts "Creating sample data for development..."

    # Create some specific iconic posters
    iconic_posters = [
      :pearl_jam_red_rocks,
      :radiohead_msg,
      :black_keys_fillmore,
      :arctic_monkeys_wembley,
      :tame_impala_observatory
    ]

    puts "Creating iconic posters..."
    iconic_posters.each do |trait|
      begin
        poster = FactoryBot.create(:poster, trait)
        puts "  ✓ #{poster.name}"
      rescue ActiveRecord::RecordInvalid => e
        puts "  ⚠ Skipped #{trait} (already exists)"
      end
    end

    # Create additional random posters
    puts "Creating additional posters..."
    5.times do
      begin
        poster = FactoryBot.create(:poster, :with_artist, :modern)
        puts "  ✓ #{poster.name}"
      rescue ActiveRecord::RecordInvalid => e
        puts "  ⚠ Skipped random poster (validation error)"
      end
    end

    puts "\nSample data created successfully!"
    puts "  Posters: #{Poster.count}"
    puts "  Artists: #{Artist.count}"
    puts "  Bands: #{Band.count}"
    puts "  Venues: #{Venue.count}"
    puts "\nYou can now:"
    puts "  1. Visit /admin to manage posters"
    puts "  2. Visit /posters to browse public posters"
    puts "  3. Sign in and add posters to your collection"
    puts "  4. Visit /user_posters to see your collection dashboard"
  end

  desc "Create sample user collections"
  task create_collections: :environment do
    puts "Creating sample user collections..."

    # Get or create a test user
    user = User.find_by(email: "test@example.com") ||
           FactoryBot.create(:user,
             email: "test@example.com",
             first_name: "Test",
             last_name: "User"
           )

    # Get some posters
    posters = Poster.limit(8)

    if posters.count < 5
      puts "Not enough posters. Run 'rails sample_data:create' first."
      exit
    end

    # Create diverse collection
    puts "Creating collection for #{user.email}..."

    # 3 owned posters
    3.times do |i|
      poster = posters[i]
      user_poster = FactoryBot.create(:user_poster, :owned, :with_edition, :with_notes,
        user: user,
        poster: poster
      )
      puts "  ✓ Added to collection: #{poster.name}"
    end

    # 2 wanted posters
    2.times do |i|
      poster = posters[i + 3]
      user_poster = FactoryBot.create(:user_poster, :wanted, :with_notes,
        user: user,
        poster: poster
      )
      puts "  ✓ Added to want list: #{poster.name}"
    end

    # 2 watching posters
    2.times do |i|
      poster = posters[i + 5]
      user_poster = FactoryBot.create(:user_poster,
        user: user,
        poster: poster,
        status: "watching"
      )
      puts "  ✓ Added to watch list: #{poster.name}"
    end

    puts "\nCollection created successfully!"
    puts "Sign in with: test@example.com / password"
    puts "Then visit /user_posters to see the collection dashboard"
  end

  desc "Clear all sample data"
  task clear: :environment do
    puts "Clearing sample data..."

    UserPoster.destroy_all
    Poster.destroy_all
    Artist.destroy_all
    Band.destroy_all
    Venue.destroy_all

    puts "Sample data cleared!"
  end
end
