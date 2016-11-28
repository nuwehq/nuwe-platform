require 'rails_helper'

describe Nu::Calculate::Biometric do

  let(:bmi) { FactoryGirl.create :bmi_measurement }

  describe "score" do
    [
      [0.5, 4],
      [0.6, 4],
      [0.64, 27],
      [0.89, 100],
      [1.0, 89],
      [1.2, 61],
      [1.4, 33],
      [1.6, 5]
    ].each do |tuple|
      prime, score = tuple.first, tuple.last
      it "translates #{prime} to #{score}" do
        bmi = FactoryGirl.create :bmi_measurement, value: prime * 25
        expect(described_class.new(bmi).score).to eq(score)
      end
    end
  end

  describe "freshness" do

    it "is 100 in the past 24 hours" do
      bmi = FactoryGirl.create :bmi_measurement, timestamp: Time.current, date: Date.current
      expect(described_class.new(bmi).freshness).to eq(100)
    end

    it "decays with time" do
      freshness = 95
      Date.yesterday.downto(20.days.ago.to_date) do |date|
        Measurement::Bmi.destroy_all
        bmi = FactoryGirl.create :bmi_measurement, timestamp: date, date: date
        expect(described_class.new(bmi).freshness).to eq(freshness)
        freshness = freshness - 5
      end
    end

    it "never goes below 0" do
      bmi = FactoryGirl.create :bmi_measurement, timestamp: 2.months.ago, date: 2.months.ago.to_date
      expect(described_class.new(bmi).freshness).to eq(0)
    end

  end

end
