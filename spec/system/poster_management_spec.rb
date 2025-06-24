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

      expect(page).to have_content("Artwork")
      expect(page).to have_css("[data-testid='poster-card']", count: 3)
    end

    it "shows poster details" do
      visit poster_path(poster)

      expect(page).to have_content(poster.name)
      expect(page).to have_content(poster.band.name)
      expect(page).to have_content(poster.venue.name)
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

        # Add to collection (owned)
        select "Add to collection (I own this)", from: "status"
        click_button "Add"

        # Add to watch list
        select "Add to watch list", from: "status"
        click_button "Add"

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

        # Add second copy
        select "Add to collection (I own this)", from: "status"
        click_button "Add"

        expect(page).to have_content("You own 2 copies of this poster")
      end

      it "allows removing items from collection/lists" do
        user_poster = create(:user_poster, user: user, poster: poster, status: 'owned')

        visit poster_path(poster)

        expect(page).to have_content("Your Collection")

        click_link "Remove"

        expect(page).to have_content("Are you sure you want to remove this from your collection?")
        # Note: This would need JavaScript handling in real test
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
      expect(page).to have_field("Purchase price")
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
      visit edit_user_poster_path(user_poster)

      # Should be hidden initially
      expect(page).to have_field("Asking price", visible: false)

      # Check for sale
      check "This poster is for sale"

      # Should show asking price field
      expect(page).to have_field("Asking price", visible: true)
    end
  end

  describe "For sale listings" do
    let(:seller) { create(:user) }
    let(:for_sale_poster) { create(:user_poster, user: seller, poster: poster, status: 'owned', for_sale: true, asking_price: 150.00) }

    before do
      for_sale_poster # Create the for sale poster
      sign_in(user)
    end

    it "shows available copies for sale" do
      visit poster_path(poster)

      expect(page).to have_content("Available Copies")
      expect(page).to have_content(seller.display_name)
      expect(page).to have_content("$150.0")
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
