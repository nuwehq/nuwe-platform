require 'rails_helper'

describe User do

  subject { FactoryGirl.create :user }

  it { should be_valid }

  it "has no roles" do
    expect(subject.roles).to eq([])
  end

  describe "age" do
    it "is calculated from birth_date" do
      Timecop.freeze(Time.local(2014, 5, 22)) do
        subject.profile.birth_date = "1975-09-16"
        expect(subject.age).to eq(38)
      end
    end
  end

  context "bmi" do
    it "is nil when no measurement present" do
      expect(subject.bmi).to be_nil
    end

    it "has most recent bmi value" do
      bmi_measurement = FactoryGirl.create :bmi_measurement, user: subject
      expect(subject.bmi).to eq(bmi_measurement.value)
    end
  end

  context "weight" do
    it "is nil when no measurement present" do
      expect(subject.weight).to be_nil
    end

    it "has most recent weight measurement value" do
      weight_measurement = FactoryGirl.create :weight_measurement, user: subject
      expect(subject.weight).to eq(weight_measurement.value)
    end
  end

  context "height" do
    it "is nil when no measurement present" do
      expect(subject.height).to be_nil
    end

    it "has most recent height measurement value" do
      height_measurement = FactoryGirl.create :height_measurement, user: subject
      expect(subject.height).to eq(height_measurement.value)
    end
  end

  context "with apps" do

    describe "humanapi" do
      before do
        FactoryGirl.create :humanapi, user: subject, credentials: {"publicToken" => "0xdeaf"}
      end

      it "exposes the public token" do
        expect(subject.humanapi_public_token).to eq("0xdeaf")
      end
    end

  end

end
