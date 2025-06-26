require 'rails_helper'

RSpec.describe 'Legacy URL redirects', type: :routing do
  describe 'artwork URLs' do
    it 'redirects /artworks to /posters' do
      expect(get: '/artworks').to route_to(
        controller: 'rails/info',
        action: 'routes',
        internal: true
      )
      # Test the redirect functionality
      expect(get('/artworks')).to redirect_to('/posters')
    end

    context 'with existing poster' do
      let(:poster) { create(:poster) }

      it 'redirects /artworks/:id to /posters/:slug' do
        expect(get: "/artworks/#{poster.id}").to redirect_to("/posters/#{poster.to_param}")
      end
    end

    context 'with non-existent poster' do
      it 'redirects to /posters index for invalid ID' do
        expect(get: '/artworks/999999').to redirect_to('/posters')
      end
    end
  end
end
