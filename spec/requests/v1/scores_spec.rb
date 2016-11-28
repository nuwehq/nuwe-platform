require 'rails_helper'

describe Nu::ScoresController do

  include_context "signed up user"
  include_context "api token authentication"
  let! (:pasta_corn_cooked) { FactoryGirl.create :pasta_corn_cooked }
  let! (:eat) { FactoryGirl.create :eat, user: user }
  let! (:old_eat) { FactoryGirl.create :old_eat, user: user }
  let! (:yesterdays_eat) { FactoryGirl.create :yesterdays_eat, user: user }
  let(:team) { FactoryGirl.create :team }


  it "returns 30 days by default" do
    get "/v1/nu/scores.json", nil, token_auth
    expect(json_body["scores"].length).to eq(30)
  end
  before do
    FactoryGirl.create :historical_score, history: user, date: Date.yesterday, biometric: 800
  end

  it "can be decreased to 7 days" do
    get "/v1/nu/scores.json?days=7", nil, token_auth
    expect(json_body["scores"].length).to eq(7)
  end

  it "cannot grow beyond 30 days" do
    get "/v1/nu/scores.json?days=700", nil, token_auth
    expect(json_body["scores"].length).to eq(30)
  end

  %w(biometric_score activity_score nutrition_score nu_score).each do |score|
    it "contains a valid #{score}" do
      get "/v1/nu/scores.json?days=7", nil, token_auth
      expect(json_body["scores"].first[score]).to be_present
      expect(json_body["scores"].first[score]).to have_key("score")
    end
  end

  describe "team history scores" do
    before do
      FactoryGirl.create :historical_score, history: user, date: Date.yesterday, biometric: 80, nutrition: 40, activity: 60
      FactoryGirl.create :membership, team: team, user: user, owner: true
      team.users << user
    end
    before do
      FactoryGirl.create :historical_score, history: team, date: Date.yesterday, activity: team.activity_score, nutrition: team.nutrition_score, biometric: team.biometric_score, nu: team.nu_score
    end
    it "contains the correct historical scores" do
      get "/v1/nu/teams/#{team.id}/scores.json?days=7", nil, token_auth
      expect(json_body["scores"].first["biometric_score"]["score"]).to eq(80)
      expect(json_body["scores"].first["nu_score"]["score"]).to eq(60)
    end
    it "connot grow beyond 30 days" do
      get "/v1/nu/teams/#{team.id}/scores.json?days=70", nil, token_auth
      expect(json_body["scores"].length).to eq(30)
    end
  end

  describe "team history with no scores" do
    it "should not break stuffs" do
      get "/v1/nu/teams/#{team.id}/scores.json?days=7", nil, token_auth
      expect(json_body["scores"].first["biometric_score"]["score"]).to eq(nil)
    end
  end

  describe "doesn't show a nutrional breakdown without DCN" do
    it "returns 30 days by default" do
      get "/v1/nu/scores.json", nil, token_auth
      expect(json_body["scores"].first["breakdown"]["breakdown"]).to eq(nil)
    end
  end

  describe "shows nutrional 30-day breakdown for users with DCN" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile_giulia
      yesterdays_eat.components.create!(ingredient_id: pasta_corn_cooked.id, amount: 240)
      Nu::Score.new(user.reload).daily_scores(Date.current)
    end
    it "returns 30 days by default" do
      get "/v1/nu/scores.json", nil, token_auth
      expect(json_body["scores"].first["breakdown"]["breakdown"]["score"]).to eq(12)
    end
  end





  describe "biometrics" do
    before do
      FactoryGirl.create :historical_score, history: user, date: Date.yesterday, biometric: 800
    end

    it "returns values stored in the db" do
      get "/v1/nu/scores.json?days=1", nil, token_auth
      result = json_body["scores"].first["biometric_score"]
      expect(result["score"]).to eq(800)
    end
  end

  describe "activities" do
    before do
      FactoryGirl.create :historical_score, history: user, date: Date.yesterday, activity: 600
    end

    it "returns values stored in the db" do
      get "/v1/nu/scores.json?days=1", nil, token_auth
      result = json_body["scores"].first["activity_score"]
      expect(result["score"]).to eq(600)
    end
  end

  describe "nutrition" do
    before do
      FactoryGirl.create :historical_score, history: user, date: Date.yesterday, nutrition: 770
    end

    it "returns values stored in the db" do
      get "/v1/nu/scores.json?days=1", nil, token_auth
      result = json_body["scores"].first["nutrition_score"]
      expect(result["score"]).to eq(770)
    end
  end

  describe "today score without DCN" do
    it "posts an error without DCN" do
      get "/v1/nu/scores/today.json", nil, token_auth
      expect(response.status).to eq(400)
    end
  end

  describe "today score with DCN" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile_giulia
      eat.components.create!(ingredient_id: pasta_corn_cooked.id, amount: 240)
      Nu::Score.new(user.reload).daily_scores(Date.current)
    end

    it "returns values stored in the db" do
      get "/v1/nu/scores/today.json", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "contains the correct scores" do
      get "/v1/nu/scores/today.json", nil, token_auth
      expect(json_body["historical_score"]["nutrition"]).to eq(12)
    end

    it "contains the correct values" do
      get "/v1/nu/scores/today.json", nil, token_auth
      expect(json_body["breakdown"]["breakdown"]["carbs"]["g"]).to eq("55.464")
    end
  end

  describe "week score with DCN" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile_giulia
      Nu::Score.new(user.reload).daily_scores(Date.yesterday)
    end
    it "returns values stored in the db" do
      get "/v1/nu/scores/week.json", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "contains the correct values" do
      get "/v1/nu/scores/week.json", nil, token_auth
      expect(json_body).to have_key("scores")
      expect(json_body["scores"].first["historical_score"]["nu"]).to eq(12)
    end
  end


end
