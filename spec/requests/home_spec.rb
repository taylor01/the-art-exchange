require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end

    it "displays the application title" do
      get "/"
      expect(response.body).to include("The Art Exchange")
    end
  end
end
