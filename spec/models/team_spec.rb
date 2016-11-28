require 'rails_helper'

describe Team do

  let(:team) { FactoryGirl.create :team }

  %i(activity_goal nutrition_goal biometric_goal).each do |goal|
    it "validates #{goal}" do
      team.send("#{goal}=", 8000)
      expect(team).to_not be_valid
    end
  end

  describe "nu score" do

    let(:user1) { FactoryGirl.create :user }
    let(:user2) { FactoryGirl.create :user }

    before do
      FactoryGirl.create :historical_score, history: user1, date: Date.yesterday, biometric: 100, nutrition: 100, activity: 100
      FactoryGirl.create :historical_score, history: user2, date: Date.yesterday, biometric: 60, nutrition: 60, activity: 60

      team.memberships.create! user: user1
      team.memberships.create! user: user2
    end

    it "is an average of all members" do
      expect(team.nu_score).to eq(80)
    end
  end

end
