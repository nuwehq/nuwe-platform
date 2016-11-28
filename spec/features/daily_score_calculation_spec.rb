require 'rails_helper'

feature "daily score calculation" do

  let(:user) { FactoryGirl.create :user }

  describe "for biometrics" do

    let!(:bmi_measurement) { FactoryGirl.create :bmi_measurement_yesterday, user: user }

    before do
      user.profile.update FactoryGirl.attributes_for :profile_female
    end


    before do
      # I wanted to invoke the rake tasks, but couldn't get it to work.
      # The code below is called by the nu:scores task.
      Nu::Score.new(user).calculate
    end

    it "has historical biometric scores" do
      expect(user.historical_scores.where(date: Date.yesterday)).to be_present
      expect(user.historical_scores.where(date: Date.yesterday).first.biometric).to eq(89)
    end
  end

  describe "for activities" do

    let!(:measurement) { FactoryGirl.create :activity_measurement_yesterday, user: user }

    before do
      user.profile.update FactoryGirl.attributes_for :profile_female
    end

    before do
      # I wanted to invoke the rake tasks, but couldn't get it to work.
      # The code below is called by the nu:scores task.
      Nu::Score.new(user).calculate
    end

    it "has historical activity scores" do
      expect(user.historical_scores.where(date: Date.yesterday)).to be_present
      expect(user.historical_scores.where(date: Date.yesterday).first.activity).to eq(45)
    end
  end

end
