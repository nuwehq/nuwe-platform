require 'rails_helper'

describe User do

  subject { FactoryGirl.create :user }

  %w(bmi weight height blood_pressure bmr bpm step).each do |type|
    describe type do
      it "is nil when no #{type} measurement present" do
        expect(subject.send(type)).to be_nil
      end

      it "has most recent #{type} value" do
        measurement = FactoryGirl.create :"#{type}_measurement", user: subject
        expect(subject.send(type)).to eq(measurement.value)
        expect(subject.measurements[type]).to eq(measurement.value)
      end
    end
  end

  describe "bmi calculation" do
    it "calculates bmi from height, and then weight" do
      height = FactoryGirl.create :height_measurement, user: subject
      weight = FactoryGirl.create :weight_measurement, user: subject
      expect(subject.bmi).to eq(bmi(weight, height))
    end

    it "calculates bmi from weight, and then height" do
      weight = FactoryGirl.create :weight_measurement, user: subject
      height = FactoryGirl.create :height_measurement, user: subject
      expect(subject.bmi).to eq(bmi(weight, height))
    end

    it "uses the most recent weight measurement" do
      FactoryGirl.create :bmi_measurement, user: subject, value: 24, timestamp: 1.month.ago
      height = FactoryGirl.create :height_measurement, user: subject, timestamp: 1.week.ago
      weight = FactoryGirl.create :weight_measurement, user: subject, timestamp: 1.week.ago
      expect(subject.bmi).to eq(bmi(weight, height))
    end
  end

  def bmi(weight_measurement, height_measurement)
    height_m = height_measurement.value / 1000
    weight_measurement.value / 1000 / height_m ** 2
  end

end
