require 'rails_helper'

RSpec.describe OtpController, type: :controller do
  let(:user) { create(:user) }

  before do
    session[:otp_user_id] = user.id
    user.generate_otp!
  end

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end

    it "redirects if no OTP session" do
      session[:otp_user_id] = nil
      get :show
      expect(response).to redirect_to(new_session_path)
    end

    it "redirects if user is already signed in" do
      session[:user_id] = user.id
      get :show
      expect(response).to redirect_to(root_path)
      expect(session[:otp_user_id]).to be_nil
    end
  end

  describe "POST #create" do
    context "with valid OTP token" do
      it "signs in user and clears OTP session" do
        post :create, params: { otp_token: user.otp_secret_key }
        expect(session[:user_id]).to eq(user.id)
        expect(session[:otp_user_id]).to be_nil
        expect(response).to redirect_to(root_path)
      end

      it "marks OTP as used" do
        post :create, params: { otp_token: user.otp_secret_key }
        expect(user.reload.otp_used_at).to be_present
      end

      it "updates login tracking" do
        post :create, params: { otp_token: user.otp_secret_key }
        expect(user.reload.last_login_at).to be_present
      end
    end

    context "with invalid OTP token" do
      it "does not sign in user" do
        post :create, params: { otp_token: "invalid" }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:show)
      end

      it "increments attempt count" do
        expect {
          post :create, params: { otp_token: "invalid" }
        }.to change { user.reload.otp_attempts_count }.by(1)
      end

      it "locks account after max attempts" do
        user.update!(otp_attempts_count: 2)
        post :create, params: { otp_token: "invalid" }
        expect(user.reload).to be_otp_locked
      end
    end

    context "with expired OTP" do
      it "rejects expired token" do
        user.update!(otp_sent_at: 1.hour.ago)
        post :create, params: { otp_token: user.otp_secret_key }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:show)
      end
    end

    context "with used OTP" do
      it "rejects already used token" do
        user.update!(otp_used_at: 1.minute.ago)
        post :create, params: { otp_token: user.otp_secret_key }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:show)
      end
    end
  end

  describe "POST #resend" do
    it "generates new OTP token" do
      old_token = user.otp_secret_key
      post :resend
      expect(user.reload.otp_secret_key).not_to eq(old_token)
    end

    it "sends new OTP email", :unstub_mailers do
      mailer_double = double("AuthenticationMailer")
      expect(mailer_double).to receive(:deliver_now).and_return(true)
      expect(AuthenticationMailer).to receive(:otp_email).with(user, anything).and_return(mailer_double)
      post :resend
    end

    it "does not resend if locked" do
      user.update!(otp_locked_until: 10.minutes.from_now)
      post :resend
      expect(response).to render_template(:show)
      expect(flash.now[:alert]).to include("Too many attempts")
    end
  end
end
