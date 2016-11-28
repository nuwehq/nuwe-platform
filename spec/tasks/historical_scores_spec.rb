require 'rails_helper'
require 'rake'

RSpec.describe "historical_scores" do

  before :all do
    Rake.application.rake_require "tasks/historical_scores"
    Rake::Task.define_task :environment
  end

  describe "teams" do

    let!(:team) { FactoryGirl.create :team }

    let :run_rake_task do
      Rake::Task["historical_scores:teams"].reenable
      Rake.application.invoke_task "historical_scores:teams"
    end

    it "creates for yesterday" do
      expect {
        run_rake_task
      }.to change(HistoricalScore, :count).by(1)
    end
  end
end
