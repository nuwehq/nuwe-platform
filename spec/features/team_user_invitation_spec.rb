require 'rails_helper'

feature "team user invitation" do

  include_context "signed up user"
  include_context "api token authentication"

  describe "with unregistered users" do

    let(:email) { Faker::Internet.email }
    let(:team) { FactoryGirl.create :team }

    before do
      FactoryGirl.create :invitation, team: team, email: email
    end

    it "adds invitees to team after sign up users" do
      FactoryGirl.create :user, email: email
      expect(team.memberships.count).to eq(1)
    end
    
    it "doesn't effect users without invitations" do
      FactoryGirl.create :user, email: "noinvite@noteam.com"
      expect(team.memberships.count).to eq(0)
    end    

  end
end
