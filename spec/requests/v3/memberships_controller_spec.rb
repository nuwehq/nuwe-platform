require 'rails_helper'

describe V3::MembershipsController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:nuwe_teams_service) { FactoryGirl.create :nuwe_teams_service}

  let(:team)          { FactoryGirl.create :team }
  let(:friend)        { FactoryGirl.create :user }

  before do
    FactoryGirl.create :capability, service_id: nuwe_teams_service.id, application_id: oauth_application.id
  end

  describe "adding existing users" do

    it "works" do
      expect {
        post "/v3/teams/#{team.id}/memberships.json", {membership: {user_id: friend.id}}, bearer_auth
      }.to change(Membership, :count).by(1)
    end

    it "returns 201 created" do
      post "/v3/teams/#{team.id}/memberships.json", {membership: {user_id: friend.id}}, bearer_auth
      expect(response.code).to eq("201")
    end

    it "does not create an ownership record" do
      post "/v3/teams/#{team.id}/memberships.json", {membership: {user_id: friend.id}}, bearer_auth
      expect(Membership.last.owner).to_not eq(true)
    end
  end

  describe "leaving a team" do

    let(:other_team) { FactoryGirl.create :team }

    before do
      FactoryGirl.create :membership, team: other_team, user: oauth_user, owner: false
    end

    it_behaves_like "a nice 404 response" do
      before do
        delete "/v3/teams/teamsnowden/membership", nil, bearer_auth
      end
    end

    it "works" do
      expect {
        delete "/v3/teams/#{other_team.id}/membership", nil, bearer_auth
      }.to change(Membership, :count).by(-1)
    end

    it "returns 200 ok" do
      delete "/v3/teams/#{other_team.id}/membership", nil, bearer_auth
      expect(response.status).to eq(200)
    end

    it "returns 404 when not a member" do
      third_team = FactoryGirl.create :team
      delete "/v3/teams/#{third_team.id}/membership", nil, bearer_auth
      expect(response.status).to eq(404)
    end

  end

  context "removing members as an admin" do

    let(:other)         { FactoryGirl.create :user }

    before do
      FactoryGirl.create :membership, team: team, user: oauth_user, owner: true
      team.users << friend
    end

    it_behaves_like "a nice 404 response" do
      before do
        delete "/v3/teams/teamsnowden/memberships/none.json", nil, bearer_auth
      end
    end

    def do_delete
      delete "/v3/teams/#{team.id}/memberships/#{friend.id}.json", nil, application_auth
    end

    it "works" do
      expect{
        do_delete
      }.to change(Membership, :count).by(-1)
    end

    it "returns ok"do
      do_delete
      expect(response.status).to eq(200)
    end

    it "shows a list of all team members" do
      FactoryGirl.create :membership, user: other, team: team
      do_delete
      expect(json_body["team"]["memberships"].length).to eq(2) # owner and friend
      expect(response.body).to include(other.email)
    end

    it "returns an error when the user was not found" do
      delete "/v3/teams/#{team.id}/memberships/70000.json", nil, bearer_auth
      expect(response.code).to eq("404")
    end

    it "only works for owners" do
      team = FactoryGirl.create :team
      friend = FactoryGirl.create :user
      team.users << friend

      delete "/v3/teams/#{team.id}/memberships/#{friend.id}.json", nil, bearer_auth
      expect(response.status).to eq(404)
    end
  end

end
