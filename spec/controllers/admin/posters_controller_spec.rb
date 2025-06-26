require 'rails_helper'

RSpec.describe Admin::PostersController, type: :controller do
  let(:admin_user) { create(:user, admin: true) }
  let(:regular_user) { create(:user, admin: false) }
  let(:poster) { create(:poster) }

  describe "admin access control" do
    context "when user is admin" do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(controller).to receive(:user_signed_in?).and_return(true)
      end

      it "allows access to index" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is not admin" do
      before do
        allow(controller).to receive(:current_user).and_return(regular_user)
        allow(controller).to receive(:user_signed_in?).and_return(true)
      end

      it "denies access to index" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Access denied.")
      end
    end
  end

  context "when user is admin" do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
      allow(controller).to receive(:user_signed_in?).and_return(true)
    end

    describe "GET #index" do
      let!(:posters) { create_list(:poster, 3) }

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns @posters" do
        get :index
        expect(assigns(:posters)).to match_array(posters)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: poster.id }
        expect(response).to have_http_status(:success)
      end

      it "assigns @poster" do
        get :show, params: { id: poster.id }
        expect(assigns(:poster)).to eq(poster)
      end

      it "renders the show template" do
        get :show, params: { id: poster.id }
        expect(response).to render_template(:show)
      end
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "assigns a new poster" do
        get :new
        expect(assigns(:poster)).to be_a_new(Poster)
      end

      it "loads form data" do
        create(:band, name: "Test Band")
        get :new
        expect(assigns(:bands)).to be_present
      end
    end

    describe "POST #create" do
      let(:band) { create(:band) }
      let(:venue) { create(:venue) }
      let(:valid_attributes) do
        {
          name: "Test Poster",
          description: "A test poster",
          release_date: "2023-01-01",
          original_price: 50.00,
          band_id: band.id,
          venue_id: venue.id
        }
      end

      context "with valid parameters" do
        it "creates a new poster" do
          expect {
            post :create, params: { poster: valid_attributes }
          }.to change(Poster, :count).by(1)
        end

        it "redirects to the poster" do
          post :create, params: { poster: valid_attributes }
          expect(response).to redirect_to(admin_poster_path(Poster.last))
        end

        it "sets a success notice" do
          post :create, params: { poster: valid_attributes }
          expect(flash[:notice]).to eq("Poster created successfully.")
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) { { name: "" } }

        it "does not create a new poster" do
          expect {
            post :create, params: { poster: invalid_attributes }
          }.not_to change(Poster, :count)
        end

        it "renders the new template" do
          post :create, params: { poster: invalid_attributes }
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        get :edit, params: { id: poster.id }
        expect(response).to have_http_status(:success)
      end

      it "assigns @poster" do
        get :edit, params: { id: poster.id }
        expect(assigns(:poster)).to eq(poster)
      end
    end

    describe "PATCH #update" do
      context "with valid parameters" do
        let(:new_attributes) { { name: "Updated Poster Name" } }

        it "updates the poster" do
          patch :update, params: { id: poster.id, poster: new_attributes }
          poster.reload
          expect(poster.name).to eq("Updated Poster Name")
        end

        it "redirects to the poster" do
          patch :update, params: { id: poster.id, poster: new_attributes }
          poster.reload # Reload to get the updated slug
          expect(response).to redirect_to(admin_poster_path(poster))
        end

        it "sets a success notice" do
          patch :update, params: { id: poster.id, poster: new_attributes }
          expect(flash[:notice]).to eq("Poster updated successfully.")
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) { { name: "" } }

        it "does not update the poster" do
          original_name = poster.name
          patch :update, params: { id: poster.id, poster: invalid_attributes }
          poster.reload
          expect(poster.name).to eq(original_name)
        end

        it "renders the edit template" do
          patch :update, params: { id: poster.id, poster: invalid_attributes }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE #destroy" do
      let!(:poster_to_delete) { create(:poster) }

      it "destroys the poster" do
        expect {
          delete :destroy, params: { id: poster_to_delete.id }
        }.to change(Poster, :count).by(-1)
      end

      it "redirects to posters index" do
        delete :destroy, params: { id: poster_to_delete.id }
        expect(response).to redirect_to(admin_posters_path)
      end

      it "sets a success notice" do
        delete :destroy, params: { id: poster_to_delete.id }
        expect(flash[:notice]).to eq("Poster deleted successfully.")
      end
    end
  end
end
