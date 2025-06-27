require 'rails_helper'

RSpec.describe 'Legacy URL redirects', type: :request do
  describe 'artwork URLs' do
    it 'redirects /artworks to /posters' do
      get '/artworks'
      expect(response).to redirect_to('/posters')
      expect(response).to have_http_status(:moved_permanently)
    end

    context 'with existing poster' do
      let(:poster) { create(:poster) }

      it 'redirects /artworks/:id to /posters/:slug' do
        get "/artworks/#{poster.id}"
        expect(response).to redirect_to("/posters/#{poster.to_param}")
        expect(response).to have_http_status(:moved_permanently)
      end
    end

    context 'with non-existent poster' do
      it 'redirects to /posters index for invalid ID' do
        get '/artworks/999999'
        expect(response).to redirect_to('/posters')
        expect(response).to have_http_status(:moved_permanently)
      end
    end
  end
end
