require 'rails_helper'

RSpec.describe "layouts/application", type: :view do
  context "when user is not signed in" do
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
      render
    end

    it "shows sign in and sign up links" do
      expect(rendered).to include("Sign In")
      expect(rendered).to include("Sign Up")
    end

    it "does not show user-specific content" do
      expect(rendered).not_to include("Profile")
      expect(rendered).not_to include("Sign Out")
    end
  end

  context "when user is signed in" do
    let(:user) { build(:user, first_name: "John") }

    before do
      allow(view).to receive(:user_signed_in?).and_return(true)
      allow(view).to receive(:current_user).and_return(user)
      render
    end

    it "shows user greeting and profile link" do
      expect(rendered).to include("Hello, John")
      expect(rendered).to include("Profile")
      expect(rendered).to include("Sign Out")
    end

    it "does not show guest links" do
      expect(rendered).not_to include("Sign In")
      expect(rendered).not_to include("Sign Up")
    end
  end
end