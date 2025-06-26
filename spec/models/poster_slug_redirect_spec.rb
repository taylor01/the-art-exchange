require 'rails_helper'

RSpec.describe PosterSlugRedirect, type: :model do
  let(:poster) { create(:poster) }
  let(:redirect) { build(:poster_slug_redirect, poster: poster, old_slug: 'old-test-slug') }

  describe 'associations' do
    it 'belongs to poster' do
      expect(redirect.poster).to eq(poster)
    end

    it 'poster has many slug redirects' do
      redirect.save!
      expect(poster.slug_redirects).to include(redirect)
    end
  end

  describe 'validations' do
    it 'validates presence of old_slug' do
      redirect.old_slug = nil
      expect(redirect).not_to be_valid
      expect(redirect.errors[:old_slug]).to include("can't be blank")
    end

    it 'validates uniqueness of old_slug' do
      redirect.save!
      duplicate = build(:poster_slug_redirect, old_slug: redirect.old_slug)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:old_slug]).to include("has already been taken")
    end

    it 'validates presence of poster' do
      redirect.poster = nil
      expect(redirect).not_to be_valid
      expect(redirect.errors[:poster]).to include("can't be blank")
    end

    describe 'old_slug_not_current_slug validation' do
      it 'prevents creating redirect with current poster slug' do
        current_slug = poster.slug
        invalid_redirect = build(:poster_slug_redirect, poster: poster, old_slug: current_slug)
        expect(invalid_redirect).not_to be_valid
        expect(invalid_redirect.errors[:old_slug]).to include("cannot be the same as the current poster slug")
      end

      it 'allows valid old slug' do
        expect(redirect).to be_valid
      end
    end
  end

  describe 'scopes' do
    describe '.by_old_slug' do
      before do
        redirect.save!
      end

      it 'finds redirect by old slug' do
        found = PosterSlugRedirect.by_old_slug('old-test-slug')
        expect(found).to include(redirect)
      end

      it 'returns empty for non-existent slug' do
        found = PosterSlugRedirect.by_old_slug('non-existent')
        expect(found).to be_empty
      end
    end
  end
end
