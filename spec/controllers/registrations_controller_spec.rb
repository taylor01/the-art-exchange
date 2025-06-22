require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "redirects if user is already signed in" do
      user = create(:user)
      session[:user_id] = user.id
      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        user: {
          email: "test@example.com",
          first_name: "John",
          last_name: "Doe"
        }
      }
    end

    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "sends confirmation email", :unstub_mailers do
        mailer_double = double("AuthenticationMailer")
        expect(mailer_double).to receive(:deliver_now).and_return(true)
        expect(AuthenticationMailer).to receive(:confirmation_email).with(anything).and_return(mailer_double)
        post :create, params: valid_params
      end

      it "redirects to confirmation sent page" do
        post :create, params: valid_params
        expect(response).to redirect_to(confirmation_sent_path)
      end

      it "generates confirmation token" do
        post :create, params: valid_params
        user = User.last
        expect(user.confirmation_token).to be_present
        expect(user.confirmation_sent_at).to be_present
      end
    end

    context "with optional password" do
      it "creates user with password" do
        params = valid_params.deep_merge(user: { password: "SecurePassword123!" })
        post :create, params: params

        user = User.last
        expect(user.password_digest).to be_present
        expect(user.authenticate("SecurePassword123!")).to eq(user)
      end
    end

    context "with invalid parameters" do
      it "does not create user with missing email" do
        params = valid_params.deep_merge(user: { email: "" })
        expect {
          post :create, params: params
        }.not_to change(User, :count)
      end

      it "renders new template with errors" do
        params = valid_params.deep_merge(user: { email: "" })
        post :create, params: params
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with duplicate email" do
      it "does not create user" do
        create(:user, email: "test@example.com")
        expect {
          post :create, params: valid_params
        }.not_to change(User, :count)
      end
    end
  end
end
