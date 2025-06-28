require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'success'
    end
  end

  let(:user_with_current_terms) { create(:user, terms_accepted_at: Time.current, terms_version: "2024-06-28") }
  let(:user_with_old_terms) { create(:user, terms_accepted_at: Time.current, terms_version: "old-version") }
  let(:user_without_terms) {
    user = build(:user, terms_accepted_at: nil, terms_version: nil)
    user.save!(validate: false)
    user
  }

  before do
    allow(Rails.application.config.authentication).to receive(:[]).and_call_original
    allow(Rails.application.config.authentication).to receive(:[]).with(:current_terms_version).and_return("2024-06-28")
    routes.draw { get 'index' => 'anonymous#index' }
  end

  describe 'terms enforcement' do
    context 'when user is not signed in' do
      it 'does not enforce terms' do
        get :index
        expect(response).to be_successful
        expect(response.body).to eq('success')
      end
    end

    context 'when user has current terms version' do
      before { sign_in(user_with_current_terms) }

      it 'allows access' do
        get :index
        expect(response).to be_successful
        expect(response.body).to eq('success')
      end
    end

    context 'when user has old terms version' do
      before { sign_in(user_with_old_terms) }

      it 'redirects to terms acceptance' do
        get :index
        expect(response).to redirect_to(terms_acceptance_path)
        expect(flash[:alert]).to eq("Please review and accept our updated Terms of Service to continue.")
      end

      it 'stores the current location for redirect after acceptance' do
        get :index
        expect(session[:user_return_to]).to eq('/index')
      end
    end

    context 'when user has no terms acceptance' do
      before { sign_in(user_without_terms) }

      it 'redirects to terms acceptance' do
        get :index
        expect(response).to redirect_to(terms_acceptance_path)
        expect(flash[:alert]).to eq("Please review and accept our updated Terms of Service to continue.")
      end
    end
  end

  describe 'skip_terms_enforcement?' do
    let(:controller_instance) { described_class.new }

    it 'skips enforcement for sessions controller' do
      allow(controller_instance).to receive(:controller_name).and_return('sessions')
      expect(controller_instance.send(:skip_terms_enforcement?)).to be true
    end

    it 'skips enforcement for registrations controller' do
      allow(controller_instance).to receive(:controller_name).and_return('registrations')
      expect(controller_instance.send(:skip_terms_enforcement?)).to be true
    end

    it 'skips enforcement for legal controller' do
      allow(controller_instance).to receive(:controller_name).and_return('legal')
      expect(controller_instance.send(:skip_terms_enforcement?)).to be true
    end

    it 'skips enforcement for terms_acceptance controller' do
      allow(controller_instance).to receive(:controller_name).and_return('terms_acceptance')
      expect(controller_instance.send(:skip_terms_enforcement?)).to be true
    end

    it 'skips enforcement for password_resets controller' do
      allow(controller_instance).to receive(:controller_name).and_return('password_resets')
      expect(controller_instance.send(:skip_terms_enforcement?)).to be true
    end

    it 'skips enforcement for otp controller' do
      allow(controller_instance).to receive(:controller_name).and_return('otp')
      expect(controller_instance.send(:skip_terms_enforcement?)).to be true
    end

    it 'does not skip enforcement for other controllers' do
      allow(controller_instance).to receive(:controller_name).and_return('posters')
      expect(controller_instance.send(:skip_terms_enforcement?)).to be false
    end
  end

  private

  def sign_in(user)
    session[:user_id] = user.id
  end
end
