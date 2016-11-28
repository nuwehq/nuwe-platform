require 'rails_helper'

describe Eat do

  it "defaults to eaten on today" do
    eat = FactoryGirl.create :eat
    expect(eat.eaten_on).to eq(Date.current)
  end

  describe "nutrients" do
    describe "from a meal" do

      let(:ingredient) { FactoryGirl.create :ingredient, protein: 80, carbs: 90, kcal: 100, fibre: 110, fat_s: 120, fat_u: 130, salt: 140, sugar: 150 }
      let(:component) { FactoryGirl.create :component, ingredient: ingredient, amount: 2 }
      let(:eat) { FactoryGirl.create :eat }
      let(:meal) { FactoryGirl.create :meal }

      before do
        meal.components << component
        eat.meals << meal
      end

      it "calculates values" do
        expect(eat.protein).to eq(160)
        expect(eat.carbs).to eq(180)
        expect(eat.kcal).to eq(200)
        expect(eat.fibre).to eq(220)
        expect(eat.fat_s).to eq(240)
        expect(eat.fat_u).to eq(260)
        expect(eat.salt).to eq(280)
        expect(eat.sugar).to eq(300)
      end
    end

    describe "from components" do
      let(:ingredient) { FactoryGirl.create :ingredient, protein: 80, carbs: 90, kcal: 100, fibre: 110, fat_s: 120, fat_u: 130, salt: 140, sugar: 150 }
      let(:component) { FactoryGirl.create :component, ingredient: ingredient, amount: 3 }
      let(:eat) { FactoryGirl.create :eat }

      before do
        eat.components << component
      end

      it "calculates values" do
        expect(eat.protein).to eq(240)
        expect(eat.carbs).to eq(270)
        expect(eat.kcal).to eq(300)
        expect(eat.fibre).to eq(330)
        expect(eat.fat_s).to eq(360)
        expect(eat.fat_u).to eq(390)
        expect(eat.salt).to eq(420)
        expect(eat.sugar).to eq(450)
      end
    end

  end
end
