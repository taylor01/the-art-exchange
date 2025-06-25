require 'rails_helper'

RSpec.describe UserPoster, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:poster) }
  end

  describe "validations" do
    it { should validate_presence_of(:status) }
    it { should validate_numericality_of(:purchase_price).is_greater_than(0).allow_nil }
    it { should validate_numericality_of(:asking_price).is_greater_than(0).allow_nil }
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values(owned: "owned", wanted: "wanted", watching: "watching").backed_by_column_of_type(:string) }
    it { should define_enum_for(:condition).with_values(
      mint: "mint", near_mint: "near_mint", very_fine: "very_fine",
      fine: "fine", very_good: "very_good", good: "good",
      fair: "fair", poor: "poor"
    ).backed_by_column_of_type(:string) }
  end

  describe "scopes" do
    let!(:user) { create(:user) }
    let!(:poster) { create(:poster) }
    let!(:owned_poster) { create(:user_poster, :owned, user: user, poster: poster) }
    let!(:wanted_poster) { create(:user_poster, :wanted, user: user) }
    let!(:watching_poster) { create(:user_poster, user: user) }
    let!(:for_sale_poster) { create(:user_poster, :for_sale, user: user) }

    describe ".owned_by" do
      it "returns posters owned by the user" do
        expect(UserPoster.owned_by(user)).to include(owned_poster, for_sale_poster)
        expect(UserPoster.owned_by(user)).not_to include(wanted_poster, watching_poster)
      end
    end

    describe ".wanted_by" do
      it "returns posters wanted by the user" do
        expect(UserPoster.wanted_by(user)).to include(wanted_poster)
        expect(UserPoster.wanted_by(user)).not_to include(owned_poster, watching_poster)
      end
    end

    describe ".watched_by" do
      it "returns posters watched by the user" do
        expect(UserPoster.watched_by(user)).to include(watching_poster)
        expect(UserPoster.watched_by(user)).not_to include(owned_poster, wanted_poster)
      end
    end

    describe ".for_sale" do
      it "returns posters marked for sale" do
        expect(UserPoster.for_sale).to include(for_sale_poster)
        expect(UserPoster.for_sale).not_to include(owned_poster, wanted_poster, watching_poster)
      end
    end

    describe ".by_poster" do
      it "returns user posters for a specific poster" do
        expect(UserPoster.by_poster(poster)).to include(owned_poster)
        expect(UserPoster.by_poster(poster)).not_to include(wanted_poster, watching_poster)
      end
    end
  end

  describe "#display_name" do
    let(:user_poster) { create(:user_poster) }

    context "without edition number" do
      it "returns poster display name" do
        expect(user_poster.display_name).to eq(user_poster.poster.display_name)
      end
    end

    context "with edition number" do
      let(:user_poster) { create(:user_poster, :with_edition, edition_number: "25/100") }

      it "includes edition number in display name" do
        expect(user_poster.display_name).to include("(#25/100)")
      end
    end
  end

  describe "#formatted_purchase_price" do
    context "with purchase price" do
      let(:user_poster) { create(:user_poster, :owned, purchase_price: 4550) }

      it "formats the price with dollar sign" do
        expect(user_poster.formatted_purchase_price).to eq("$45.50")
      end
    end

    context "without purchase price" do
      let(:user_poster) { create(:user_poster) }

      it "returns not specified message" do
        expect(user_poster.formatted_purchase_price).to eq("Not specified")
      end
    end
  end

  describe "#formatted_asking_price" do
    context "when for sale with asking price" do
      let(:user_poster) { create(:user_poster, :for_sale, asking_price: 8000) }

      it "formats the asking price with dollar sign" do
        expect(user_poster.formatted_asking_price).to eq("$80.00")
      end
    end

    context "when not for sale" do
      let(:user_poster) { create(:user_poster, :owned) }

      it "returns not for sale message" do
        expect(user_poster.formatted_asking_price).to eq("Not for sale")
      end
    end

    context "when for sale but no asking price" do
      let(:user_poster) { create(:user_poster, :owned, for_sale: true, asking_price: nil) }

      it "returns not for sale message" do
        expect(user_poster.formatted_asking_price).to eq("Not for sale")
      end
    end
  end

  describe "multiple copies scenario" do
    let(:user) { create(:user) }
    let(:poster) { create(:poster) }

    it "allows multiple copies of the same poster for the same user" do
      copy1 = create(:user_poster, :owned, user: user, poster: poster, edition_number: "1/100", condition: "mint")
      copy2 = create(:user_poster, :owned, user: user, poster: poster, edition_number: "50/100", condition: "near_mint")

      expect(user.user_posters.by_poster(poster).count).to eq(2)
      expect(copy1).to be_valid
      expect(copy2).to be_valid
    end
  end
end
