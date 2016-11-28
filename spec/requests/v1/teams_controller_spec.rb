require 'rails_helper'

describe V1::TeamsController do

  include_context "signed up user"
  include_context "api token authentication"

  describe "index" do
    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/teams.json"
      end
    end

    it "returns the user's teams" do
      team = FactoryGirl.create :team, name: "EMEA Equity"
      team.users << user
      get "/v1/teams.json", nil, token_auth
      expect(json_body["teams"]).to be_present
      expect(json_body["teams"].first["name"]).to eq("EMEA Equity")
    end
  end

  describe "create" do
    it "works" do
      expect {
        post "/v1/teams.json", {team: {name: "EMEA Equity"}}, token_auth
      }.to change(Team, :count).by(1)
    end

    it "returns 201 created" do
      post "/v1/teams.json", {team: {name: "EMEA Equity"}}, token_auth
      expect(response.code).to eq("201")
    end

    it "creates an ownership record" do
      post "/v1/teams.json", {team: {name: "EMEA Equity"}}, token_auth
      membership = user.memberships.last
      expect(membership).to be_present
      expect(membership.owner).to eq(true)
    end

    it "allows goal values to be set" do
      post "/v1/teams.json", {team: {name: "EMEA Equity", activity_goal: 80, biometric_goal: 90, nutrition_goal: 100}}, token_auth
      team = Team.find json_body["team"]["id"]
      expect(team.activity_goal).to eq(80)
      expect(team.biometric_goal).to eq(90)
      expect(team.nutrition_goal).to eq(100)
    end
  end

  describe "show" do
    let(:team) { FactoryGirl.create :team, activity_goal: 80, nutrition_goal: 90, biometric_goal: 100 }

    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/teams/#{team.id}.json"
      end
    end

    it_behaves_like "a nice 404 response" do
      before do
        delete "/v1/teams/teamsnowden.json", nil, token_auth
      end
    end

    it "works" do
      FactoryGirl.create :membership, team: team, user: user
      get "/v1/teams/#{team.id}.json", nil, token_auth
      expect(response.status).to eq(200)
      expect(json_body["team"]).to be_present
    end

    it "contains goals" do
      FactoryGirl.create :membership, team: team, user: user
      get "/v1/teams/#{team.id}.json", nil, token_auth
      expect(json_body["team"]["activity_goal"]).to eq(80)
      expect(json_body["team"]["nutrition_goal"]).to eq(90)
      expect(json_body["team"]["biometric_goal"]).to eq(100)
    end

    it "contains memberships" do
      other = FactoryGirl.create :user
      FactoryGirl.create :membership, team: team, user: user
      FactoryGirl.create :membership, team: team, user: other
      get "/v1/teams/#{team.id}.json", nil, token_auth
      expect(json_body["team"]["memberships"].count).to be(2)
      expect(response.body).to include(other.to_param)
    end

    it "does not show other's team" do
      get "/v1/teams/#{team.id}.json", nil, token_auth
      expect(response.status).to eq(404)
      expect(json_body["error"]).to be_present
    end
  end

  describe "achievements" do
    let(:team) { FactoryGirl.create :team }

    before do
      FactoryGirl.create :achievement, name: "milestone.5", team: team
      FactoryGirl.create :achievement, name: "streak.activity.5", team: team
      FactoryGirl.create :achievement, name: "streak.nutrition.5", team: team, created_at: 1.week.ago
      FactoryGirl.create :achievement, name: "goal.activity", team: team
      FactoryGirl.create :achievement, name: "highest.activity", team: team

      FactoryGirl.create :membership, team: team, user: user
    end

    it "contains all achievements" do
      get "/v1/teams/#{team.id}.json", nil, token_auth
      expect(json_body["team"]["achievements"].count).to eq(5)
      expect(response.body).to include("highest.activity")
    end

    it "has the oldest achievement first" do
      get "/v1/teams/#{team.id}.json", nil, token_auth
      expect(json_body["team"]["achievements"].first["name"]).to eq("streak.nutrition.5")
    end

    it "contains the achievement description" do
      get "/v1/teams/#{team.id}.json", nil, token_auth
      expect(json_body["team"]["achievements"].first["description"]).to eq("Team #{team.name} has reached its nutrition goal for 5 consecutive days. Good job!")
    end
  end

  describe "update" do
    let(:team) { FactoryGirl.create :team }

    before do
      FactoryGirl.create :membership, team: team, user: user, owner: true
    end

    it_behaves_like "a nice 404 response" do
      before do
        put "/v1/teams/teamsnowden.json", nil, token_auth
      end
    end

    it "can change the name" do
      put "/v1/teams/#{team.id}.json", {team: {name: "Ohaio"}}, token_auth
      expect(team.reload.name).to eq("Ohaio")
    end

    %w(activity_goal biometric_goal nutrition_goal).each do |goal|
      it "can change the #{goal} goal" do
        put "/v1/teams/#{team.id}.json", {team: {goal => 50}}, token_auth
        expect(team.reload.send(goal)).to eq(50)
      end
    end
  end

  describe "destroy" do
    let(:team) { FactoryGirl.create :team }

    before do
      FactoryGirl.create :membership, team: team, user: user, owner: true
    end

    it_behaves_like "a nice 404 response" do
      before do
        delete "/v1/teams/teamsnowden.json", nil, token_auth
      end
    end

    it "deletes the team" do
      delete "/v1/teams/#{team.id}", nil, token_auth
      expect(Team.exists?(team.id)).to be_falsy
    end

    it "returns status ok" do
      delete "/v1/teams/#{team.id}", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "does not work for non-owners" do
      other_team = FactoryGirl.create :team
      delete "/v1/teams/#{other_team.id}", nil, token_auth
      expect(response.status).to eq(400)
    end
  end

  describe "invitation" do
    let(:email) { Faker::Internet.email }
    let(:team) { FactoryGirl.create :team }

    it_behaves_like "a nice 404 response" do
      before do
        post "/v1/teams/teamsnowden/invitations.json", nil, token_auth
      end
    end

    it "works" do
      post "/v1/teams/#{team.id}/invitations", {invitation: {email: email}}, token_auth
      expect(response.code).to eq("201")
    end

    it "persists the invitation" do
      expect {
        post "/v1/teams/#{team.id}/invitations", {invitation: {email: email}}, token_auth
      }.to change(Invitation, :count).by(1)
    end

    it "sends an email" do
      Sidekiq::Testing.inline! do
        post "/v1/teams/#{team.id}/invitations", {invitation: {email: email}}, token_auth
      end
      last_email = ActionMailer::Base.deliveries.last
      expect(last_email.to).to include(email)
    end
  end

end
