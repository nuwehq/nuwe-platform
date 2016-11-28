require 'rails_helper'
require 'rake'

describe "Doorkeeper::Application" do

  let(:user) { FactoryGirl.create :user }
  let(:oauth_application) { FactoryGirl.create :oauth_application, owner: user}
  let(:subscription) { FactoryGirl.create :subscription }

  let(:usda_service) { FactoryGirl.create :usda_service }
  let(:nuwe_meals_service) { FactoryGirl.create :nuwe_meals_service }
  let(:nuwe_standard_security) { FactoryGirl.create :nuwe_standard_security }
  let(:nuscore_service) { FactoryGirl.create :nuscore_service }
  let(:nuwe_nutrition_service) { FactoryGirl.create :nuwe_nutrition_service }
  let(:nuwe_teams_service) { FactoryGirl.create :nuwe_teams_service }

  before :all do
    Rake.application.rake_require "tasks/limit_counter"
    Rake::Task.define_task(:environment)
  end

  it "the standard DEV plan has no valid purchase" do
    expect(oauth_application.valid_purchase?).to eq(false)
  end

  it "has several services switched on by default" do
    expect(oauth_application.capabilities.count).to eq(6)
  end

  it "can have valid purchases" do
    Purchase.create! subscription_id: subscription.id, application_id: oauth_application.id, expires_on: (Date.current + 1.year)
    expect(oauth_application.valid_purchase?).to eq(true)
  end

  context "with resource owners" do

    before do
      FactoryGirl.create_list :access_grant, 3, application: oauth_application, resource_owner_id: 1000 # always use the same
    end

    it "groups by resource owner id" do
      expect(oauth_application.resource_owners.length).to eq(1)
    end
  end

  context "the limits lock an app" do
    let(:test_subscription) { FactoryGirl.create :test_subscription}

    before do
      Purchase.create! subscription_id: test_subscription.id, application_id: oauth_application.id, expires_on: (Date.current + 1.year)
    end

    let :run_rake_task do
      Rake::Task["limit_counter:create"].reenable
      Rake.application.invoke_task "limit_counter:create"
    end

    it "if there are too many users" do
      5.times { FactoryGirl.create :access_grant, application: oauth_application }
      run_rake_task
      oauth_application.reload
      expect(oauth_application.user_limit).to eq(true)
      expect(ActionMailer::Base.deliveries.last.subject).to include("user limit")
    end

    it "if there were too many requests" do
      5.times { FactoryGirl.create :stat, application_id: oauth_application.id }
      run_rake_task
      oauth_application.reload
      expect(oauth_application.request_limit).to eq(true)
      expect(ActionMailer::Base.deliveries.last.subject).to include("request limit")
    end

    it "only if the count requests are within the last 30 days" do
      5.times { FactoryGirl.create :old_stat, application_id: oauth_application.id }
      run_rake_task
      oauth_application.reload
      expect(oauth_application.request_limit).to eq(false)
    end
  end
end
