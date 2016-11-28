require 'rails_helper'

describe Nu::Calculate::Activity do

  let(:user) { FactoryGirl.create :user }

  it "LAF is 1.37 by default" do
    Nu::Score.new(user).daily_scores(Date.current)
    expect(user.historical_scores.find_by(date: Date.current).try(:laf)).to eq(1.37)
  end

  it "score is 37 by default" do
    expect(described_class.new(user).score).to eq(37)
  end

  describe "measurements" do

    [
      {duration: 3000, type: "stationary", score: 0, laf: 1},
      {duration: 9000, type: "walking", score: 100, laf: 2},
      {duration: 4500, type: "running", score: 100, laf: 2},
      {duration: 4500, type: "cycling", score: 100, laf: 2}
    ].each do |measurement|

      it "translates #{measurement[:duration]} seconds #{measurement[:type]} to #{measurement[:score]}" do
        FactoryGirl.create :activity_measurement, user: user, duration: measurement[:duration], type: measurement[:type]
        expect(described_class.new(user).score).to eq(measurement[:score])
      end

      it "translates #{measurement[:duration]} minutes #{measurement[:type]} to #{measurement[:laf]}" do
        FactoryGirl.create :activity_measurement, user: user, duration: measurement[:duration], type: measurement[:type]
        expect(described_class.new(user).laf).to eq(measurement[:laf])
      end

    end

    describe "activity score based on calories without gender or DCN" do

      it "works" do
        FactoryGirl.create :activity_measurement, user: user, calories: 2000, type: "calories"
        expect(described_class.new(user).score).to eq(85)
      end
    end

    describe "activity score based on calories" do
      before do
        user.profile.update FactoryGirl.attributes_for :profile_giulia
        Nu::Score.new(user).daily_scores(Date.current)
      end

      it "works with a DCN measurement" do 
        FactoryGirl.create :activity_measurement, user: user, calories: 500, type: "calories"
        expect(described_class.new(user.reload).score).to eq(26)
      end
    end

    describe "can handle multiple activity_measurements" do
      it "gives the correct score" do
        FactoryGirl.create :activity_measurement, user: user, source: "moves", type: "walking", duration: 2092
        FactoryGirl.create :activity_measurement, user: user, source: "moves", type: "cycling", duration: 3426
        FactoryGirl.create :activity_measurement, user: user, source: "withings", type: "calories", calories: 36
        expect(described_class.new(user.reload).score).to eq(100)
      end
    end


    describe "fallback to static level" do
      before do
        user.preferences.where(name: "use_health_data").destroy_all
        user.preferences.create! name: "use_health_data", value: "false"
      end

      it "works" do
        FactoryGirl.create :activity_measurement, user: user, duration: 75, type: "cycling"
        user.profile.update_column :activity, 1
        expect(described_class.new(user).score).to eq(20)
      end
    end

  end

  describe "steps" do

    [
      {count: 800, score: 4, laf: 1.04},
      {count: 900, score: 5, laf: 1.05}
    ].each do |steps|

      it "translates #{steps[:count]} into score #{steps[:score]}" do
        FactoryGirl.create :step_measurement, user: user, value: steps[:count]
        expect(described_class.new(user).score).to eq(steps[:score])
      end

      it "translates #{steps[:count]} into laf #{steps[:laf]}" do
        FactoryGirl.create :step_measurement, user: user, value: steps[:count]
        expect(described_class.new(user).laf).to eq(steps[:laf])
      end

    end
  end

  describe "activity level fallback" do

    [
      {level: 1, score: 20, laf: 1.2},
      {level: 2, score: 37, laf: 1.37},
      {level: 3, score: 55, laf: 1.55},
      {level: 4, score: 72, laf: 1.72},
      {level: 5, score: 90, laf: 1.9}
    ].each do |activity|

      it "translates #{activity[:level]} into score #{activity[:score]}" do
        user.profile.update_column :activity, activity[:level]
        expect(described_class.new(user).score).to eq(activity[:score])
      end

      it "translates #{activity[:level]} into laf #{activity[:laf]}" do
        user.profile.update_column :activity, activity[:level]
        expect(described_class.new(user).laf).to eq(activity[:laf])
      end

    end

  end

end
