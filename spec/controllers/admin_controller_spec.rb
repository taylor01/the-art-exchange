require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  describe "GET #index" do
    context "when user is admin" do
      let(:admin_user) { create(:user, admin: true) }

      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(controller).to receive(:user_signed_in?).and_return(true)
      end

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "when user is not admin" do
      let(:regular_user) { create(:user, admin: false) }

      before do
        allow(controller).to receive(:current_user).and_return(regular_user)
        allow(controller).to receive(:user_signed_in?).and_return(true)
      end

      it "redirects to root path" do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it "sets access denied alert" do
        get :index
        expect(flash[:alert]).to eq("Access denied.")
      end
    end

    context "when user is not signed in" do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
        allow(controller).to receive(:user_signed_in?).and_return(false)
      end

      it "redirects to root path" do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
