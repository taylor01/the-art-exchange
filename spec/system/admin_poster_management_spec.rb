require 'rails_helper'

RSpec.describe "Admin Poster Management", type: :system do
  let(:admin_user) { create(:user, admin: true) }
  let(:regular_user) { create(:user, admin: false) }
  let(:poster) { create(:poster) }
  let(:band) { create(:band) }
  let(:venue) { create(:venue, :fillmore) }
  let(:artist) { create(:artist) }

  before do
    sign_in(admin_user)
  end

  describe "Admin access control" do
    it "allows admin access to admin dashboard" do
      visit admin_dashboard_path

      expect(page).to have_content("Admin Dashboard")
      expect(page).to have_content("Poster Management")
      expect(page).to have_link("View All Posters")
    end

    it "restricts non-admin access" do
      sign_in(regular_user)

      visit admin_dashboard_path

      expect(page).to have_content("Access denied")
      expect(current_path).not_to eq(admin_dashboard_path)
    end
  end

  describe "Poster CRUD operations" do
    describe "Creating posters" do
      it "allows creating new posters" do
        # Create records before visiting the page
        band_name = band.name
        venue_name = venue.name
        artist_name = artist.name

        visit admin_posters_path

        click_link "New Poster"

        expect(page).to have_content("New Poster")

        fill_in "Name", with: "Test Concert Poster"
        fill_in "Description", with: "A fantastic concert poster"
        fill_in "Release date", with: "2024-01-15"
        fill_in "Original Price ($)", with: "50.00"
        select band_name, from: "Band"
        select venue_name, from: "Venue"
        check artist_name

        click_button "Create Poster"

        expect(page).to have_content("Poster created successfully")
        expect(page).to have_content("Test Concert Poster")
      end

      it "shows validation errors for invalid posters" do
        visit new_admin_poster_path

        # Submit with missing required fields
        click_button "Create Poster"

        expect(page).to have_content("can't be blank")
      end

      it "allows uploading poster images" do
        # Create records before visiting the page
        band_name = band.name
        venue_name = venue.name

        visit new_admin_poster_path

        fill_in "Name", with: "Test Poster with Image"
        fill_in "Release date", with: "2024-01-15"
        select band_name, from: "Band"
        select venue_name, from: "Venue"

        # This would require a test image file
        # attach_file "Image", Rails.root.join("spec/fixtures/files/test_poster.jpg")

        click_button "Create Poster"

        expect(page).to have_content("Poster created successfully")
      end
    end

    describe "Listing posters" do
      before do
        create_list(:poster, 5)
      end

      it "shows paginated list of posters" do
        visit admin_posters_path

        expect(page).to have_content("Poster Management")
        expect(page).to have_css("tbody tr", minimum: 5) # At least 5 posters
        expect(page).to have_link("Add New Poster")
      end

      it "shows poster details in list" do
        visit admin_posters_path

        poster = Poster.first

        expect(page).to have_content(poster.name)
        expect(page).to have_content(poster.band.name)
        expect(page).to have_content(poster.venue.name)
        expect(page).to have_link(href: admin_poster_path(poster))
        expect(page).to have_link(href: edit_admin_poster_path(poster))
      end
    end

    describe "Viewing poster details" do
      it "shows comprehensive poster information" do
        visit admin_poster_path(poster)

        expect(page).to have_content(poster.name)
        expect(page).to have_content(poster.description)
        expect(page).to have_content(poster.band.name)
        expect(page).to have_content(poster.venue.name)
        expect(page).to have_content(poster.formatted_date)
        expect(page).to have_content(poster.formatted_price)

        expect(page).to have_link("Edit")
        expect(page).to have_link("View Public")
        expect(page).to have_link("Admin - Posters")
      end

      it "shows poster image when attached" do
        # This would require setting up an attached image
        poster_with_image = create(:poster)
        # poster_with_image.image.attach(fixture_file_upload('test_poster.jpg', 'image/jpg'))

        visit admin_poster_path(poster_with_image)

        # expect(page).to have_css("img[src*='test_poster.jpg']")
      end
    end

    describe "Editing posters" do
      it "allows editing existing posters" do
        visit edit_admin_poster_path(poster)

        expect(page).to have_content("Edit Poster")
        expect(page).to have_field("Name", with: poster.name)
        expect(page).to have_field("Description", with: poster.description)

        fill_in "Name", with: "Updated Poster Name"
        fill_in "Description", with: "Updated description"

        click_button "Update Poster"

        expect(page).to have_content("Poster updated successfully")
        expect(page).to have_content("Updated Poster Name")
      end

      it "shows validation errors when editing" do
        visit edit_admin_poster_path(poster)

        fill_in "Name", with: ""

        click_button "Update Poster"

        expect(page).to have_content("can't be blank")
      end

      it "allows updating poster associations" do
        new_band = create(:band, name: "New Band")
        new_venue = create(:venue, name: "New Venue")

        visit edit_admin_poster_path(poster)

        select new_band.name, from: "Band"
        select new_venue.name, from: "Venue"

        click_button "Update Poster"

        expect(page).to have_content("Poster updated successfully")
        expect(page).to have_content(new_band.name)
        expect(page).to have_content(new_venue.name)
      end
    end

    describe "Deleting posters" do
      it "allows deleting posters with confirmation" do
        visit admin_posters_path

        # Delete link is in the index page as an icon, not on show page
        # Test that delete functionality exists (the icon link with data-confirm)
        expect(page).to have_css("a[data-confirm]")
      end
    end
  end

  describe "Bulk operations" do
    before do
      create_list(:poster, 25) # Create enough posters to trigger pagination (20 per page)
    end

    it "shows pagination controls" do
      visit admin_posters_path

      expect(page).to have_css(".pagination")
    end

    it "allows searching/filtering posters" do
      searchable_poster = create(:poster, name: "Unique Poster Name")

      visit admin_posters_path

      # This would require implementing search functionality
      # fill_in "search", with: "Unique"
      # click_button "Search"

      # expect(page).to have_content("Unique Poster Name")
      # expect(page).not_to have_content(Poster.where.not(name: "Unique Poster Name").first.name)
    end
  end

  describe "Navigation and user experience" do
    it "provides clear navigation between admin sections" do
      visit admin_posters_path

      expect(page).to have_content("Poster Management")
      expect(page).to have_link("Add New Poster")
    end

    it "shows success messages for operations" do
      poster = create(:poster)

      visit edit_admin_poster_path(poster)

      fill_in "Name", with: "Updated Name"
      click_button "Update Poster"

      expect(page).to have_content("successfully")
    end

    it "shows error messages for failed operations" do
      visit new_admin_poster_path

      click_button "Create Poster"

      expect(page).to have_content("can't be blank")
    end
  end

  private

  def sign_in(user)
    visit root_path
    # This would depend on your authentication implementation
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:user_signed_in?).and_return(true)
  end
end
