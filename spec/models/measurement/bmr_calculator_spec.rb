require 'rails_helper'

describe Measurement::BmrCalculator do

  let(:user) { FactoryGirl.create :user }

  describe "value" do
    [
      [85, 182, 38, 'M', 1802.5],
      [80, 185, 32, 'M', 1801.25],
      [60, 180, 33, 'F', 1399],
      [90, 200, 24, nil, nil]
    ].each do |person|
      it "calculates bmr for #{person}" do
        weight, height, age, sex, bmr = *person
        calculator = Measurement::BmrCalculator.new(weight, height, age, sex)
        expect(calculator.value).to eq(bmr)
      end
    end
  end
end
