require 'rails_helper'

describe Nu::Score do

  include_context "signed up user"
  include_context "api token authentication"

  before do
    FactoryGirl.create :historical_score, history: user, date: Date.current, biometric: 45, nutrition: 9, activity: 12
    FactoryGirl.create :historical_score, history: user, date: Date.yesterday, biometric: 77, nutrition: 33, activity: 55
    FactoryGirl.create :historical_score, history: user, date: Date.yesterday - 1.day, biometric: 16, nutrition: 22, activity: 7
    FactoryGirl.create :historical_score, history: user, date: Date.yesterday - 2.day, biometric: 46, nutrition: 12, activity: 3
  end

  it "calculates the correct biometric score" do
    Nu::Score.new(user).daily_scores(Date.current)
    expect(user.biometric_score).to eq(46)
  end

  it "calculates the correct activity score" do
    Nu::Score.new(user).daily_scores(Date.current)
    expect(user.activity_score).to eq(21)
  end

  it "calculates the correct nutrtional score" do
    Nu::Score.new(user).daily_scores(Date.current)
    expect(user.nutrition_score).to eq(22)
  end
end
