require 'rails_helper'

describe V1::NotificationsController do

  include_context "signed up user"
  include_context "api token authentication"

  let(:team) { FactoryGirl.create :team }

  describe "#create" do

    include_context "throttle"

    before do
      FactoryGirl.create :membership, team: team, user: user
    end

    it_behaves_like "a nice 404 response" do
      before do
        post "/v1/teams/teamsnowden/notifications", nil, token_auth
      end
    end

    it "works" do
      post "/v1/teams/#{team.id}/notifications", {notification: {text: "Hi team!"}}, token_auth
      expect(response.code).to eq("201")
    end

    it "creates a notification" do
      expect {
        post "/v1/teams/#{team.id}/notifications", {notification: {text: "Hi team!"}}, token_auth
      }.to change {
        team.team_notifications.count
      }.by 1
    end

    it "contains the notification in the response" do
      post "/v1/teams/#{team.id}/notifications", {notification: {text: "Hi team!"}}, token_auth
      expect(json_body["notification"]["text"]).to eq("Hi team!")
    end

    it "does not work for non-members" do
      other = FactoryGirl.create :team
      post "/v1/teams/#{other.id}/notifications", {notification: {text: "Hi team!"}}, token_auth
      expect(response.status).to eq(404)
    end

    it "is rate limited" do
      post "/v1/teams/#{team.id}/notifications", {notification: {text: "Hi team!"}}, token_auth
      post "/v1/teams/#{team.id}/notifications", {notification: {text: "Hi team!"}}, token_auth
      expect(response.status).to eq(429)
    end

    describe "APN", broken: true do

      let(:grocer_server) { GrocerServer.instance.server }

      before do
        other = FactoryGirl.create :user
        FactoryGirl.create :device, user: other
        FactoryGirl.create :membership, team: team, user: other

        grocer_server.accept
      end

      after do
        grocer_server.close
      end

      it "relays the notification to APN" do
        Sidekiq::Testing.inline! do
          post "/v1/teams/#{team.id}/notifications", {notification: {text: "Hi team!"}}, token_auth
        end

        Timeout.timeout(3) do
          notification = grocer_server.notifications.pop
          expect(notification.alert).to eq("Hi team!")
        end
      end

      context "when first name of the sender is known" do
        let(:first_name) { Faker::Name.first_name }
        before do
          user.profile.update_attribute :first_name, first_name
        end

        it "prefixes the sender's first name" do
          Sidekiq::Testing.inline! do
            post "/v1/teams/#{team.id}/notifications", {notification: {text: "Hi team!"}}, token_auth
          end

          Timeout.timeout(3) do
            notification = grocer_server.notifications.pop
            expect(notification.alert).to eq("#{first_name}: Hi team!")
          end
        end
      end
    end

  end
end
