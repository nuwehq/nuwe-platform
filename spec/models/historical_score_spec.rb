require 'rails_helper'

RSpec.describe HistoricalScore, :type => :model do

  let(:team) { FactoryGirl.create :team }

  it "can have a day before" do
    historical_score = FactoryGirl.create :historical_score, history: team, date: Date.current
    day_before = FactoryGirl.create :historical_score, history: team, date: Date.yesterday
    expect(historical_score.day_before.id).to eq(day_before.id)
  end

  it "can have a day after" do
    historical_score = FactoryGirl.create :historical_score, history: team, date: Date.current
    day_tomorrow = FactoryGirl.create :historical_score, history: team, date: Date.tomorrow
    expect(historical_score.day_tomorrow.id).to eq(day_tomorrow.id)
  end
end
