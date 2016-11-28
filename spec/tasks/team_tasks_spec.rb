require 'rails_helper'
require 'rake'

RSpec.describe Achievement, :type => :model, broken: true do

  before :all do
    Rake.application.rake_require "tasks/teams"
    Rake::Task.define_task(:environment)
  end

  let :run_rake_task do
    Rake::Task["teams:achievements"].reenable
    Rake.application.invoke_task "teams:achievements"
  end

  let(:team_90) { FactoryGirl.create :team_90, :device_users }
  let(:no_goal_team) { FactoryGirl.create :team }

  let(:grocer_server) { GrocerServer.instance.server }

  before do
    grocer_server.accept
  end

  after do
    grocer_server.close
  end

  describe "milestones" do

    describe "5 days" do

      let!(:team) { FactoryGirl.create :team, :device_users, created_at: 5.days.ago, name: "YMCA" }

      it "creates 1" do
        expect {
          run_rake_task
        }.to change(team.achievements.where("name like 'milestone%'"), :count).by(1)
      end

      it "relays a push notification to all team members" do
        Sidekiq::Testing.inline! do
          run_rake_task
        end

        Timeout.timeout(3) do
          notification = grocer_server.notifications.pop
          expect(notification.alert).to eq("Team YMCA has been tracking for 5 days. Good job!")
        end
      end
    end

    describe "10 days" do

      let!(:team) { FactoryGirl.create :team, :device_users, created_at: 10.days.ago, name: "YMCA" }

      it "creates 2" do
        expect {
          run_rake_task
        }.to change(team.achievements.where("name like 'milestone%'"), :count).by(2)
      end

      it "relays a push notification to all team members" do
        Sidekiq::Testing.inline! do
          run_rake_task
        end

        Timeout.timeout(3) do
          notification = grocer_server.notifications.pop
          notification = grocer_server.notifications.pop
          expect(notification.alert).to eq("Team YMCA has been tracking for 10 days. Keep it up!")
        end
      end

    end

    describe "20 days" do

      let!(:team) { FactoryGirl.create :team, :device_users, created_at: 20.days.ago, name: "YMCA" }

      it "creates 3" do
        expect {
          run_rake_task
        }.to change(team.achievements.where("name like 'milestone%'"), :count).by(3)
      end

      it "relays a push notification to all team members" do
        Sidekiq::Testing.inline! do
          run_rake_task
        end

        Timeout.timeout(3) do
          notification = grocer_server.notifications.pop
          notification = grocer_server.notifications.pop
          notification = grocer_server.notifications.pop
          expect(notification.alert).to eq("Team YMCA has been tracking for 20 days. Go team!")
        end
      end

    end

    describe "50 days" do

      let!(:team) { FactoryGirl.create :team, :device_users, created_at: 50.days.ago, name: "YMCA" }

      it "creates 4 for 50-day milestone" do
        expect {
          run_rake_task
        }.to change(team.achievements.where("name like 'milestone%'"), :count).by(4)
      end

      it "relays a push notification to all team members" do
        Sidekiq::Testing.inline! do
          run_rake_task
        end

        Timeout.timeout(3) do
          notification = grocer_server.notifications.pop
          notification = grocer_server.notifications.pop
          notification = grocer_server.notifications.pop
          notification = grocer_server.notifications.pop
          expect(notification.alert).to eq("Team YMCA has been tracking for 50 days. Excellent!")
        end
      end
    end

  end

  describe "streaks" do

    %i(activity nutrition biometric).each do |score|
      it "does not create one when goal not set" do
        0.upto(5).each do |day|
          FactoryGirl.create :historical_score, history: no_goal_team, date: Date.current - day.days, "#{score}" => 91
        end

        expect {
          run_rake_task
        }.to_not change(team_90.achievements.where("name like 'streak%'"), :count)
      end

      it "creates one for 5-day #{score} streak" do
        0.upto(5).each do |day|
          FactoryGirl.create :historical_score, history: team_90, date: Date.current - day.days, "#{score}" => 91
        end

        expect {
          run_rake_task
        }.to change(team_90.achievements.where("name like 'streak%'"), :count).by(1)
      end

      it "relays a push notification to all team members" do
        0.upto(5).each do |day|
          FactoryGirl.create :historical_score, history: team_90, date: Date.current - day.days, "#{score}" => 91
        end

        Sidekiq::Testing.inline! do
          run_rake_task
        end

        Timeout.timeout(3) do
          notification = grocer_server.notifications.pop
          expect(notification.alert).to eq("Team #{team_90.name} has reached its #{score} goal for 5 consecutive days. Good job!")
        end
      end

      it "does not create one for 5 non-consequetive #{score} scores" do
        0.upto(5).each do |day|
          s = FactoryGirl.create :historical_score, history: team_90, date: Date.current - (day * 2).days, "#{score}" => 91
        end

        expect {
          run_rake_task
        }.to_not change(team_90.achievements.where("name like 'streak%'"), :count)
      end

      it "creates two for 10-day #{score} streak" do
        0.upto(10).each do |day|
          FactoryGirl.create :historical_score, history: team_90, date: Date.current - day.days, "#{score}" => 91
        end

        expect {
          run_rake_task
        }.to change(team_90.achievements.where("name like 'streak%'"), :count).by(2)
      end

      it "relays a push notification to all team members" do
        0.upto(10).each do |day|
          FactoryGirl.create :historical_score, history: team_90, date: Date.current - day.days, "#{score}" => 91
        end

        Sidekiq::Testing.inline! do
          run_rake_task
        end

        Timeout.timeout(3) do
          notification = grocer_server.notifications.pop
          notification = grocer_server.notifications.pop
          expect(notification.alert).to eq("Team #{team_90.name} has reached its #{score} goal for 10 consecutive days. Keep it up!")
        end
      end
    end

  end

  describe "goals" do

    before do
      FactoryGirl.create :historical_score, history: team_90, date: Date.yesterday, activity: 90
    end

    it "creates one for goal achieved" do

      expect {
        run_rake_task
      }.to change(team_90.achievements.where("name like 'goal%'"), :count).by(1)
    end

    it "relays a push notification to all team members" do
      Sidekiq::Testing.inline! do
        run_rake_task
      end

      Timeout.timeout(3) do
        notification = grocer_server.notifications.pop
        expect(notification.alert).to eq("Activity goal for team #{team_90.name} unlocked. Time to relax. But not too long!")
      end
    end

    it "does not create the goal achieved one twice" do
      FactoryGirl.create :historical_score, history: team_90, date: Date.today, activity: 90

      expect {
        run_rake_task
      }.to change(team_90.achievements.where("name like 'goal%'"), :count).by(1)
    end

  end

  describe "hiscore" do

    describe "after 3 days of scoring" do

      before do
        team_90.update_attribute :created_at, 4.days.ago

        FactoryGirl.create :historical_score, history: team_90, date: 4.days.ago, activity: 90
        FactoryGirl.create :historical_score, history: team_90, date: 3.days.ago, activity: 90
        FactoryGirl.create :historical_score, history: team_90, date: 2.days.ago, activity: 90
        FactoryGirl.create :historical_score, history: team_90, date: 1.days.ago, activity: 95
      end

      it "creates a hiscore after 3 days of scoring" do
        expect {
          run_rake_task
        }.to change(team_90.achievements.where("name like 'highest%'"), :count).by(1)
      end

      it "relays a push notification to all team members" do
        Sidekiq::Testing.inline! do
          run_rake_task
        end

        Timeout.timeout(3) do
          notification = grocer_server.notifications.pop # first one is for goal reached
          notification = grocer_server.notifications.pop
          expect(notification.alert).to eq("Team #{team_90.name} has reached its highest activity score ever.")
        end
      end
    end


    it "does not create a hiscore immediately" do
      FactoryGirl.create :historical_score, history: team_90, activity: 91

      expect {
        run_rake_task
      }.to_not change(team_90.achievements.where("name like 'highest%'"), :count)
    end

    it "only creates hiscore for actual higher scores" do
      team_90.update_attribute :created_at, 4.days.ago

      FactoryGirl.create :historical_score, history: team_90, date: 4.days.ago, activity: 90
      FactoryGirl.create :historical_score, history: team_90, date: 3.days.ago, activity: 90
      FactoryGirl.create :historical_score, history: team_90, date: 2.days.ago, activity: 90
      FactoryGirl.create :historical_score, history: team_90, date: 1.days.ago, activity: 85

      expect {
        run_rake_task
      }.to_not change(team_90.achievements.where("name like 'highest%'"), :count)
    end

  end

end
