require 'rails_helper'

describe Meal do

  let(:meal) { FactoryGirl.create :meal }

  describe "nutrients" do

    let(:ingredient) { FactoryGirl.create :ingredient }

    before do
      meal.components.create! ingredient: ingredient, amount: 2
    end

    it "calculates based on components" do
      expect(meal.protein).to be_within(0.001).of(0.0218)
      expect(meal.carbs).to be_within(0.001).of(0.1602)
      expect(meal.kcal).to be_within(0.001).of(1.78)
      expect(meal.fibre).to be_within(0.001).of(0.052)
      expect(meal.fat_s).to be_within(0.001).of(0.00224)
      expect(meal.fat_u).to be_within(0.001).of(0.0021)
      expect(meal.salt).to be_within(0.001).of(0.00005)
      expect(meal.sugar).to be_within(0.001).of(0.2446)
    end

  end

end
