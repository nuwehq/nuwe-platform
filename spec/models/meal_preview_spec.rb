require 'rails_helper'

describe MealPreview do

  let(:user) { FactoryGirl.create :user }
  let!(:turkey_whl_meat) { FactoryGirl.create :turkey_whl_meat }
  let!(:pasta_corn_cooked) { FactoryGirl.create :pasta_corn_cooked }
  let!(:carrots_raw) { FactoryGirl.create :carrots_raw }
  let!(:banana_raw) { FactoryGirl.create :banana_raw }
  let!(:apple_raw_with_skin) { FactoryGirl.create :apple_raw_with_skin }
  let!(:egg_fresh_raw) { FactoryGirl.create :egg_fresh_raw }
  let!(:potatoes_raw_skin) { FactoryGirl.create :potatoes_raw_skin }

  context "without DCN" do
    it "responds with an error message" do
      expect {
        MealPreview.new(user, components: [])
      }.to raise_error(MealPreview::DcnNeededError)
    end
  end

  context "with DCN" do

    before do
      user.profile.update FactoryGirl.attributes_for :profile_sergio
      Nu::Score.new(user).daily_scores(Date.current)
    end

    let(:totals) { meal_preview.results["nutrient_totals"] }
    let(:predicted_perc) { meal_preview.results["predicted_nutrient_perc"] }
    let(:predicted) { meal_preview.results["predicted_nutrient_totals"] }

    describe "nothing eaten yet" do

      describe "without components" do

        let(:meal_preview) do
          MealPreview.new(user, components: [])
        end

        it "contains 0 nutrients" do
          expect(totals["kcal"]).to eq(0)
          expect(totals["protein"]).to eq(0)
          expect(totals["fibre"]).to eq(0)
          expect(totals["carbs"]).to eq(0)
          expect(totals["fat_s"]).to eq(0)
          expect(totals["fat_u"]).to eq(0)
          expect(totals["salt"]).to eq(0)
          expect(totals["sugar"]).to eq(0)
        end
      end

    end

    describe "with a meal" do

      let(:meal) { FactoryGirl.create :supper }
      let(:meal_preview) do
        MealPreview.new(user, meal: meal)
      end

      it "contains the meal's nutrient values" do
        expect(totals["kcal"]).to be_within(0.01).of(2.52)
        expect(totals["protein"]).to be_within(0.01).of(0.0526)
        expect(totals["fibre"]).to be_within(0.01).of(0.096)
        expect(totals["carbs"]).to be_within(0.01).of(0.4622)
        expect(totals["fat_u"]).to be_within(0.01).of(0.01032)
        expect(totals["fat_s"]).to be_within(0.01).of(0.00204)
        expect(totals["salt"]).to be_within(0.01).of(0.0)
        expect(totals["sugar"]).to be_within(0.01).of(0.0)
      end
    end

    describe "with individual components" do

      let(:meal_preview) do
        MealPreview.new(user, components: [{ingredient_id: turkey_whl_meat.id, amount: 120}, {ingredient_id: carrots_raw.id, amount: 40}, {ingredient_id: pasta_corn_cooked.id, amount: 240}])
      end

      it "contains just the component's nutrient values" do
        expect(totals["kcal"]).to be_within(0.01).of(509.6)
        expect(totals["protein"]).to be_within(0.01).of(41.556)
        expect(totals["fibre"]).to be_within(0.01).of(12.64)
        expect(totals["carbs"]).to be_within(0.01).of(56.28)
        expect(totals["fat_u"]).to be_within(0.01).of(4.046)
        expect(totals["fat_s"]).to be_within(0.01).of(1.618)
        expect(totals["salt"]).to be_within(0.01).of(0.372000)
        expect(totals["sugar"]).to be_within(0.01).of(1.896)
      end

      it "contains nutrient percentages" do
        expect(predicted_perc["kcal"]).to be_within(0.1).of(16.391)
        expect(predicted_perc["protein"]).to be_within(0.1).of(41.23)
        expect(predicted_perc["fibre"]).to be_within(0.1).of(52.666)
        expect(predicted_perc["carbs"]).to be_within(0.1).of(17.578)
        expect(predicted_perc["fat_u"]).to be_within(0.1).of(5.833)
        expect(predicted_perc["fat_s"]).to be_within(0.1).of(5.060)
        expect(predicted_perc["salt"]).to be_within(0.1).of(6.2)
        expect(predicted_perc["sugar"]).to be_within(0.1).of(1.479)
      end

    end

    context "eaten one banana earlier" do

      let(:meal_preview) do
        MealPreview.new(user, components: [{ingredient_id: turkey_whl_meat.id, amount: 120}, {ingredient_id: carrots_raw.id, amount: 40}, {ingredient_id: pasta_corn_cooked.id, amount: 240}])
      end

      before do
        eat = FactoryGirl.create :eat, user: user
        eat.components << Component.create([ingredient_id: banana_raw.id, amount: 120])
      end

      it "contains the sum of eaten + component nutrient values" do
        expect(predicted["kcal"]).to be_within(0.01).of(616.4)
        expect(predicted["protein"]).to be_within(0.01).of(42.864)
        expect(predicted["fibre"]).to be_within(0.01).of(15.76)
        expect(predicted["carbs"]).to be_within(0.01).of(65.892)
        expect(predicted["fat_u"]).to be_within(0.01).of(4.172)
        expect(predicted["fat_s"]).to be_within(0.01).of(1.7524)
        expect(predicted["salt"]).to be_within(0.01).of(0.375)
        expect(predicted["sugar"]).to be_within(0.01).of(16.572)
      end

    end

    describe "one earlier meal eaten" do

      let(:meal_preview) do
        MealPreview.new(user, components: [{ingredient_id: turkey_whl_meat.id, amount: 120}, {ingredient_id: carrots_raw.id, amount: 40}, {ingredient_id: pasta_corn_cooked.id, amount: 240}])
      end

      before do
        meal = FactoryGirl.create :meal, user: user
        meal.components << Component.create([ingredient_id: banana_raw.id, amount: 120])
        eat = FactoryGirl.create :eat, user: user
        eat.meals << Meal.find(meal.id)
      end

      it "contains the sum of eaten + component nutrient values" do
        expect(meal_preview.results["predicted_nutrient_totals"]["kcal"]).to be_within(0.01).of(616.4)
      end

    end

    describe "earlier meal and an individual ingredient eaten" do

      let(:meal_preview) do
        MealPreview.new(user, components: [{ingredient_id: turkey_whl_meat.id, amount: 120}, {ingredient_id: carrots_raw.id, amount: 40}, {ingredient_id: pasta_corn_cooked.id, amount: 240}])
      end

      before do
        meal = FactoryGirl.create :meal, user: user
        meal.components << Component.create([ingredient_id: banana_raw.id, amount: 120])
        eat = FactoryGirl.create :eat, user: user
        eat.meals << Meal.find(meal.id)
        eat.components << Component.create([ingredient_id: apple_raw_with_skin.id, amount: 250])
        Nu::Score.new(user).daily_scores(Date.current)
      end

      it "contains the sum of eaten + component nutrient values" do
        expect(meal_preview.results["predicted_nutrient_totals"]["kcal"]).to be_within(0.01).of(746.4)
      end

      it "returns 16 score difference" do
        expect(meal_preview.results["prediction"]["difference"]).to eq(16)
        expect(meal_preview.results["prediction"]["score"]).to eq(27)
      end
    end

  end
end
