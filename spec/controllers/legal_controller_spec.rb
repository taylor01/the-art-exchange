require "rails_helper"

RSpec.describe LegalController, type: :controller do
  describe "GET #terms_of_service" do
    it "returns a successful response" do
      get :terms_of_service
      expect(response).to be_successful
    end

    it "assigns the page title" do
      get :terms_of_service
      expect(assigns(:page_title)).to eq("Terms of Service")
    end
  end

  describe "GET #privacy_policy" do
    it "returns a successful response" do
      get :privacy_policy
      expect(response).to be_successful
    end

    it "assigns the page title" do
      get :privacy_policy
      expect(assigns(:page_title)).to eq("Privacy Policy")
    end
  end
end
