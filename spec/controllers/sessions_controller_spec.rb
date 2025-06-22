require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "redirects if user is already signed in" do
      sign_in_user(user)
      get :new
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #create" do
    context "with valid email and OTP method" do
      it "generates OTP and redirects to verification" do
        post :create, params: { email: user.email, login_method: "otp" }
        expect(user.reload.otp_secret_key).to be_present
        expect(session[:otp_user_id]).to eq(user.id)
        expect(response).to redirect_to(otp_verification_path)
      end

      it "sends OTP email", :unstub_mailers do
        mailer_double = double("AuthenticationMailer")
        expect(mailer_double).to receive(:deliver_now).and_return(true)
        expect(AuthenticationMailer).to receive(:otp_email).with(user, anything).and_return(mailer_double)
        post :create, params: { email: user.email, login_method: "otp" }
      end
    end

    context "with valid email and password method" do
      let(:user) { create(:user, :with_password) }

      it "signs in user with correct password" do
        post :create, params: {
          email: user.email,
          login_method: "password",
          password: "SecurePassword123!"
        }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
      end

      it "rejects incorrect password" do
        post :create, params: {
          email: user.email,
          login_method: "password",
          password: "wrong"
        }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to include("Invalid email or password")
      end
    end

    context "with unconfirmed user" do
      let(:user) { create(:user, :unconfirmed) }

      it "rejects login attempt" do
        post :create, params: { email: user.email, login_method: "otp" }
        expect(session[:otp_user_id]).to be_nil
        expect(response).to render_template(:new)
      end
    end

    context "with locked account" do
      let(:user) { create(:user, :locked) }

      it "shows locked account message" do
        post :create, params: { email: user.email, login_method: "otp" }
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to include("temporarily locked")
      end
    end
  end

  describe "DELETE #destroy" do
    it "signs out user and redirects" do
      sign_in_user(user)
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end

  private

  def sign_in_user(user)
    session[:user_id] = user.id
  end
end
