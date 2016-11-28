require 'rails_helper'

  describe Nu::ScoresController do

  include_context "signed up user"
  include_context "api token authentication"
  let! (:pasta_corn_cooked) { FactoryGirl.create :pasta_corn_cooked }
  let! (:eat) { FactoryGirl.create :eat, user: user }

  describe "today score with DCN" do
    before do
      user.historical_scores.where(date: Date.yesterday).destroy_all
      FactoryGirl.create :historical_score, history: user, date: Date.current, biometric: 60, activity: 60, nutrition: 60
      FactoryGirl.create :historical_score, history: user, date: Date.yesterday, biometric: 80, activity: 30, nutrition: 26
      FactoryGirl.create :historical_score, history: user, date: Date.yesterday - 1.day, biometric: 10, activity: 15, nutrition: 86
      FactoryGirl.create :weight_measurement, user: user
      FactoryGirl.create :height_measurement, user: user
      user.profile.update FactoryGirl.attributes_for :profile_female
      eat.components.create!(ingredient_id: pasta_corn_cooked.id, amount: 240)
      Nu::Score.new(user).daily_scores(Date.current)
    end

    it "returns values stored in the db" do
      get "/v2/nu/scores/today.json", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "contains the correct scores" do
      get "/v2/nu/scores/today.json", nil, token_auth
      expect(json_body["nutrition_score"]).to eq(56)
    end

    it "contains the correct values" do
      get "/v2/nu/scores/today.json", nil, token_auth
      expect(json_body["breakdown"]["breakdown"]["fat_u"]["g"]).to eq("1.2384")
    end
  end
end
