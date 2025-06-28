require 'rails_helper'

RSpec.describe TermsAcceptanceController, type: :controller do
  let(:user) { create(:user, terms_accepted_at: Time.current, terms_version: "old-version") }

  before do
    allow(Rails.application.config.authentication).to receive(:[]).and_call_original
    allow(Rails.application.config.authentication).to receive(:[]).with(:current_terms_version).and_return("2024-06-28")
  end

  describe 'before_action filters' do
    it 'requires authentication' do
      get :show
      expect(response).to redirect_to(new_session_path)
    end

    it 'skips terms enforcement for this controller' do
      sign_in(user)
      # If terms enforcement wasn't skipped, this would redirect to terms_acceptance_path
      get :show
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    before { sign_in(user) }

    it 'renders the terms acceptance page' do
      get :show
      expect(response).to be_successful
      expect(response).to render_template(:show)
    end

    it 'sets page title' do
      get :show
      expect(assigns(:page_title)).to eq("Accept Terms of Service")
    end

    it 'sets current terms version' do
      get :show
      expect(assigns(:current_terms_version)).to eq("2024-06-28")
    end

    it 'sets user terms version' do
      get :show
      expect(assigns(:user_terms_version)).to eq("old-version")
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    context 'when terms are accepted' do
      it 'accepts terms and redirects to root' do
        patch :update, params: { terms_accepted: "1" }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Thank you for accepting our Terms of Service.")
        expect(user.reload.terms_version).to eq("2024-06-28")
      end

      it 'redirects to stored location if present' do
        session[:user_return_to] = "/posters"

        patch :update, params: { terms_accepted: "1" }

        expect(response).to redirect_to("/posters")
      end
    end

    context 'when terms are not accepted' do
      it 'redirects back with error message' do
        patch :update, params: { terms_accepted: "0" }

        expect(response).to redirect_to(terms_acceptance_path)
        expect(flash[:alert]).to eq("You must accept the Terms of Service to continue using the platform.")
      end

      it 'does not update user terms' do
        expect {
          patch :update, params: { terms_accepted: "0" }
        }.not_to change { user.reload.terms_version }
      end
    end

    context 'when terms_accepted parameter is missing' do
      it 'redirects back with error message' do
        patch :update, params: {}

        expect(response).to redirect_to(terms_acceptance_path)
        expect(flash[:alert]).to eq("You must accept the Terms of Service to continue using the platform.")
      end
    end
  end

  private

  def sign_in(user)
    session[:user_id] = user.id
  end
end
