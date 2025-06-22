require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { create(:user) }

  before do
    session[:user_id] = user.id
  end

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end

    it "requires authentication" do
      session[:user_id] = nil
      get :show
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit
      expect(response).to have_http_status(:success)
    end

    it "requires authentication" do
      session[:user_id] = nil
      get :edit
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "PATCH #update" do
    let(:valid_params) do
      {
        user: {
          first_name: "Updated",
          last_name: "Name",
          email: "updated@example.com"
        }
      }
    end

    context "with valid parameters" do
      it "updates the user" do
        patch :update, params: valid_params
        user.reload
        expect(user.first_name).to eq("Updated")
        expect(user.last_name).to eq("Name")
        expect(user.email).to eq("updated@example.com")
      end

      it "redirects to profile page" do
        patch :update, params: valid_params
        expect(response).to redirect_to(profile_path)
        expect(flash[:notice]).to include("successfully")
      end
    end

    context "with password update" do
      it "updates password when provided" do
        params = valid_params.deep_merge(user: {
          password: "NewPassword123!",
          password_confirmation: "NewPassword123!"
        })
        patch :update, params: params
        user.reload
        expect(user.authenticate("NewPassword123!")).to eq(user)
      end
    end

    context "with invalid parameters" do
      it "renders edit template with errors" do
        params = valid_params.deep_merge(user: { email: "invalid" })
        patch :update, params: params
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it "requires authentication" do
      session[:user_id] = nil
      patch :update, params: valid_params
      expect(response).to redirect_to(new_session_path)
    end
  end
end
