require 'rails_helper'

RSpec.describe PostersController, type: :controller do
  let(:poster) { create(:poster) }

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
    context "when user is not signed in" do
      it "returns http success" do
        get :show, params: { id: poster.id }
        expect(response).to have_http_status(:success)
      end

      it "assigns @poster" do
        get :show, params: { id: poster.id }
        expect(assigns(:poster)).to eq(poster)
      end

      it "assigns empty @user_posters" do
        get :show, params: { id: poster.id }
        expect(assigns(:user_posters)).to eq([])
      end

      it "assigns @for_sale_copies" do
        get :show, params: { id: poster.id }
        expect(assigns(:for_sale_copies)).to be_an(ActiveRecord::Relation)
      end

      it "renders the show template" do
        get :show, params: { id: poster.id }
        expect(response).to render_template(:show)
      end
    end

    context "when user is signed in" do
      let(:user) { create(:user) }
      let!(:user_poster) { create(:user_poster, :owned, user: user, poster: poster) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:user_signed_in?).and_return(true)
      end

      it "assigns user's posters for this poster" do
        get :show, params: { id: poster.id }
        expect(assigns(:user_posters)).to include(user_poster)
      end

      it "loads for sale copies from other users" do
        other_user = create(:user)
        for_sale_poster = create(:user_poster, :for_sale, user: other_user, poster: poster)

        get :show, params: { id: poster.id }
        expect(assigns(:for_sale_copies)).to include(for_sale_poster)
      end
    end

    context "when poster doesn't exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get :show, params: { id: 999999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "slug and ID parameter handling" do
      it "finds poster by slug" do
        get :show, params: { id_or_slug: poster.slug }
        expect(assigns(:poster)).to eq(poster)
        expect(response).to have_http_status(:success)
      end

      it "finds poster by ID when slug doesn't exist" do
        get :show, params: { id_or_slug: poster.id.to_s }
        expect(assigns(:poster)).to eq(poster)
        expect(response).to have_http_status(:success)
      end

      it "raises error for non-existent slug or ID" do
        expect {
          get :show, params: { id_or_slug: 'non-existent-slug' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
