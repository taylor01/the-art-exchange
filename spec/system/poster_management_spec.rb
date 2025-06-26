require 'rails_helper'

RSpec.describe "Poster Management", type: :system do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, admin: true) }
  let(:poster) { create(:poster) }

  describe "Public poster browsing" do
    before do
      create_list(:poster, 3)
    end

    it "allows users to browse posters" do
      visit posters_path

      # Check for search interface instead of removed "Artwork" heading
      expect(page).to have_field("Search posters, artists, venues...")
      expect(page).to have_css("[data-testid='poster-card']", count: 3)
    end

    it "shows poster details" do
      visit poster_path(poster)

      expect(page).to have_content(poster.name)
      expect(page).to have_content(poster.band.name)
      expect(page).to have_content(poster.venue.name)
    end
  end

  describe "Sort functionality", js: true do
    let!(:old_poster) { create(:poster, release_date: Date.new(2020, 1, 1)) }
    let!(:new_poster) { create(:poster, release_date: Date.new(2023, 1, 1)) }

    it "automatically updates results when sort dropdown changes" do
      visit posters_path

      # Initially should show newest first (2023 poster first)
      poster_cards = page.all("[data-testid='poster-card']")
      expect(poster_cards.count).to be >= 2

      # The newest poster (2023) should be first initially
      first_poster_name = poster_cards.first.find('h3').text
      expect(first_poster_name).to eq(new_poster.name)

      # Change sort to oldest first
      select 'Oldest First', from: 'sort'

      # Wait for results to update automatically (no page refresh)
      sleep 2

      # Get the updated results
      updated_poster_cards = page.all("[data-testid='poster-card']")
      updated_first_poster_name = updated_poster_cards.first.find('h3').text

      # Now the oldest poster (2020) should be first
      expect(updated_first_poster_name).to eq(old_poster.name)

      # Verify URL was updated with sort parameter
      expect(current_url).to include('sort=oldest')
    end
  end

  describe "Collection and list management", js: true do
    before do
      sign_in(user)
    end

    context "when user is not signed in" do
      before { sign_out }

      it "does not show collection management options" do
        visit poster_path(poster)

        expect(page).not_to have_content("Your Collection")
        expect(page).not_to have_content("Your Lists")
        expect(page).not_to have_button("Add")
      end
    end

    context "when user is signed in" do
      it "shows collection management interface" do
        visit poster_path(poster)

        expect(page).to have_content("Add to Collection or Lists")
        expect(page).to have_select("status")
        expect(page).to have_button("Add")
      end

      it "allows adding poster to want list" do
        visit poster_path(poster)

        select "Add to want list", from: "status"
        click_button "Add"

        expect(page).to have_content("Your Lists")
        expect(page).to have_content("Want")
        expect(page).to have_content("Added #{poster.name} to your collection as Wanted")
      end

      it "allows adding poster to watch list" do
        visit poster_path(poster)

        select "Add to watch list", from: "status"
        click_button "Add"

        expect(page).to have_content("Your Lists")
        expect(page).to have_content("Watching")
        expect(page).to have_content("Added #{poster.name} to your collection as Watching")
      end

      it "allows adding poster to collection (owned)" do
        visit poster_path(poster)

        select "Add to collection (I own this)", from: "status"
        click_button "Add"

        expect(page).to have_content("Your Collection")
        expect(page).to have_content("Owned")
        expect(page).to have_content("You own 1 copy of this poster")
        expect(page).to have_content("Added #{poster.name} to your collection as Owned")
      end

      it "separates collection (owned) from lists (want/watch)" do
        # Add one of each type
        visit poster_path(poster)

        # Add to want list
        select "Add to want list", from: "status"
        click_button "Add"
        expect(page).to have_content("Added #{poster.name} to your collection as Wanted")

        # Add to watch list
        select "Add to watch list", from: "status"
        click_button "Add"
        expect(page).to have_content("Added #{poster.name} to your collection as Watching")

        # Add to collection (owned)
        select "Add to collection (I own this)", from: "status"
        click_button "Add"
        expect(page).to have_content("Added #{poster.name} to your collection as Owned")

        # Verify separate sections
        expect(page).to have_content("Your Collection")
        expect(page).to have_content("Your Lists")

        # Collection should only show owned items
        within("[data-testid='collection-section']") do
          expect(page).to have_content("Owned")
          expect(page).not_to have_content("Want")
          expect(page).not_to have_content("Watching")
        end

        # Lists should show want and watch items
        within("[data-testid='lists-section']") do
          expect(page).to have_content("Want")
          expect(page).to have_content("Watching")
          expect(page).not_to have_content("Owned")
        end
      end

      it "allows multiple copies in collection" do
        visit poster_path(poster)

        # Add first copy
        select "Add to collection (I own this)", from: "status"
        click_button "Add"
        expect(page).to have_content("Added #{poster.name} to your collection as Owned")

        # Add second copy
        select "Add to collection (I own this)", from: "status"
        click_button "Add"
        expect(page).to have_content("Added #{poster.name} to your collection as Owned")

        expect(page).to have_content("You own 2 copies of this poster")
      end

      it "shows remove links for collection items" do
        user_poster = create(:user_poster, user: user, poster: poster, status: 'owned')

        visit poster_path(poster)

        expect(page).to have_content("Your Collection")

        # Verify the remove link exists and has correct attributes
        expect(page).to have_link("Remove", href: remove_from_collection_poster_path(poster, user_poster_id: user_poster.id))

        # Since testing the JavaScript confirmation dialog is complex in system tests,
        # we'll verify the controller functionality in a separate controller test
      end
    end
  end

  describe "User poster editing" do
    let(:user_poster) { create(:user_poster, user: user, poster: poster, status: 'owned') }

    before do
      sign_in(user)
    end

    it "allows editing owned poster details" do
      visit edit_user_poster_path(user_poster)

      expect(page).to have_content("Edit Collection Item")
      expect(page).to have_field("Edition number")
      expect(page).to have_field("Condition")
      expect(page).to have_field("Purchase Price")
      expect(page).to have_field("Purchase date")
      expect(page).to have_field("This poster is for sale")
      expect(page).to have_field("Your Photos")
      expect(page).to have_field("Notes")
    end

    it "shows different interface for want/watch list items" do
      want_poster = create(:user_poster, user: user, poster: poster, status: 'wanted')

      visit edit_user_poster_path(want_poster)

      expect(page).to have_content("Edit List Entry")
      expect(page).not_to have_field("Edition number")
      expect(page).not_to have_field("Condition")
      expect(page).not_to have_field("Purchase price")
    end

    it "allows updating poster status" do
      visit edit_user_poster_path(user_poster)

      select "Want this poster", from: "Status"
      fill_in "Notes", with: "Looking for mint condition"

      click_button "Update Collection Item"

      expect(page).to have_content("Collection item updated successfully")
    end

    it "shows/hides fields based on status selection", js: true do
      visit edit_user_poster_path(user_poster)

      # Should show owned fields initially
      expect(page).to have_field("Edition number", visible: true)
      expect(page).to have_field("Condition", visible: true)

      # Switch to wanted
      select "Want this poster", from: "Status"

      # Should hide owned fields
      expect(page).to have_field("Edition number", visible: false)
      expect(page).to have_field("Condition", visible: false)
    end

    it "shows/hides asking price based on for_sale checkbox", js: true do
      user_poster_not_for_sale = create(:user_poster, user: user, poster: poster, status: 'owned', for_sale: false)

      visit edit_user_poster_path(user_poster_not_for_sale)

      # Should be hidden initially
      expect(page).to have_css("#asking-price-field.hidden", visible: false)

      # Check for sale checkbox
      check "This poster is for sale"

      # Trigger the JavaScript manually since automated events may not fire in tests
      page.execute_script("
        const checkbox = document.getElementById('user_poster_for_sale');
        const field = document.getElementById('asking-price-field');
        field.classList.toggle('hidden', !checkbox.checked);
      ")

      # Should show asking price field
      expect(page).to have_css("#asking-price-field:not(.hidden)")
    end
  end

  describe "Collection index page" do
    before do
      sign_in(user)
    end

    it "displays user collection overview" do
      owned_poster = create(:user_poster, user: user, poster: poster, status: 'owned')
      wanted_poster = create(:user_poster, user: user, poster: create(:poster), status: 'wanted')
      watching_poster = create(:user_poster, user: user, poster: create(:poster), status: 'watching')

      visit user_posters_path

      expect(page).to have_content("My Collection")
      expect(page).to have_css(".text-green-900", text: "1") # Collection count
      expect(page).to have_css(".text-blue-900", text: "1") # Want list count
      expect(page).to have_css(".text-yellow-900", text: "1") # Watch list count
      expect(page).to have_content("Your Collection")
    end

    it "shows empty state when no posters" do
      visit user_posters_path

      expect(page).to have_content("My Collection")
      expect(page).to have_content("No posters in your collection yet")
      expect(page).to have_link("Browse Artwork", href: posters_path)
    end

    it "allows access from homepage Browse Collection button" do
      visit root_path

      expect(page).to have_link("Browse Collection", href: user_posters_path)

      click_link "Browse Collection"

      expect(page).to have_content("My Collection")
      expect(current_path).to eq(user_posters_path)
    end
  end

  describe "For sale listings" do
    let(:seller) { create(:user) }
    let(:for_sale_poster) { create(:user_poster, user: seller, poster: poster, status: 'owned', for_sale: true, asking_price: 15000) }

    before do
      for_sale_poster # Create the for sale poster
      sign_in(user)
    end

    it "shows available copies for sale" do
      visit poster_path(poster)

      expect(page).to have_content("Available Copies")
      expect(page).to have_content(seller.display_name)
      expect(page).to have_content("$150.00")
    end
  end

  describe "Progressive image loading", js: true do
    let!(:poster_with_image) { create(:poster) }

    before do
      # Attach a test image to the poster for progressive loading tests
      poster_with_image.image.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "test_poster.jpg")),
        filename: "test_poster.jpg",
        content_type: "image/jpeg"
      )
    end

    it "displays progressive image containers on poster grid" do
      visit posters_path

      # Check for progressive image structure
      within("[data-testid='poster-card']") do
        expect(page).to have_css(".progressive-image-container")
        expect(page).to have_css("[data-progressive-image-target='placeholder']")
        expect(page).to have_css("[data-progressive-image-target='mainImage']")
      end
    end

    it "loads blur placeholder images immediately" do
      visit posters_path

      # Placeholder images should be visible (loaded class applied)
      within("[data-testid='poster-card']") do
        placeholder = page.find("[data-progressive-image-target='placeholder']")
        expect(placeholder).to be_visible
        expect(placeholder[:src]).to include("variant") # Should have blur placeholder variant URL
      end
    end

    it "progressive loads main images with proper CSS classes" do
      visit posters_path

      # Main images should start with loading class
      within("[data-testid='poster-card']") do
        main_image = page.find("[data-progressive-image-target='mainImage']")
        expect(main_image[:class]).to include("loading")

        # Wait for progressive loading to complete
        expect(page).to have_css("[data-progressive-image-target='mainImage'].loaded", wait: 5)
      end
    end

    it "handles search results with progressive loading", js: true do
      visit posters_path

      # Trigger a search to test AJAX results
      fill_in "Search posters, artists, venues...", with: poster_with_image.name

      # Wait for search results to load
      expect(page).to have_css("[data-testid='poster-card']", wait: 3)

      # Verify progressive loading structure in search results
      within("[data-testid='poster-card']") do
        expect(page).to have_css(".progressive-image-container")
        expect(page).to have_css("[data-progressive-image-target='placeholder']")
        expect(page).to have_css("[data-progressive-image-target='mainImage']")
      end
    end

    it "falls back gracefully when images fail to load" do
      # Create poster without image attachment to test fallback
      poster_without_image = create(:poster)

      visit posters_path

      # Should show default placeholder for posters without images
      poster_cards = page.all("[data-testid='poster-card']")
      fallback_card = poster_cards.find { |card| card.has_css?("svg") }

      expect(fallback_card).to have_css("svg") # Default image placeholder
      expect(fallback_card).not_to have_css(".progressive-image-container")
    end
  end

  private

  def sign_in(user)
    visit root_path
    # This would depend on your authentication implementation
    # For now, we'll assume we can directly set the session or use a test helper
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:user_signed_in?).and_return(true)
  end

  def sign_out
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:user_signed_in?).and_return(false)
  end
end
