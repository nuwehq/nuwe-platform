require 'rails_helper'

describe HealthDataWorker do

  context "humanapi" do

    let(:app) { FactoryGirl.create :humanapi }

    describe "all" do
      it "fetches all weight data" do
        Timecop.freeze Time.utc(2014, 9, 5, 12, 19) do
          VCR.use_cassette "health_data_worker/humanapi/all" do
            expect {
              subject.perform(app.id, all: true)
            }.to change(Measurement::Weight, :count).by(60)
          end
        end
      end
    end

    describe "synchronize" do
      it "fetches new weight data" do
        Timecop.freeze Time.utc(2014, 9, 5, 12, 19) do
          VCR.use_cassette "health_data_worker/humanapi/synchronize" do
            subject.perform(app.id)
          end
        end
      end
    end
  end

  context "moves" do

    let(:app) { FactoryGirl.create :moves_app }

    describe "all" do
      it "fetches 56 activity measurements" do
        Timecop.freeze Time.utc(2014, 10, 22, 13) do
          VCR.use_cassette "health_data_worker/moves/all" do
            expect {
              subject.perform(app.id, all: true)
            }.to change(Measurement::Activity, :count).by(56)
          end
        end
      end
    end

    describe "synchronize" do
      it "fetches only new activities" do
        Timecop.freeze Time.utc(2014, 10, 22, 13) do
          FactoryGirl.create :activity_measurement, user: app.user, date: 3.days.ago, timestamp: 3.days.ago

          VCR.use_cassette "health_data_worker/moves/synchronize" do
            expect {
              subject.perform(app.id)
            }.to change(Measurement::Activity, :count).by(12)
          end
        end
      end
    end
  end

  context "fitbit" do
    # Fitbit is strict about the Timecop freeze, make sure you pass correct UTC/GMT times.
    # Height and weight and profile tests, depend on user with Token 4ee35ec6-6af3-41dc-a4d9-7755ca316690
    # to never have these values set.

    let(:app) { FactoryGirl.create :fitbit_app }

    describe "all" do
      it "fetches 61 activity measurements" do
        Timecop.freeze Time.utc(2014, 10, 2, 14, 52) do
          VCR.use_cassette "health_data_worker/fitbit/all" do
            expect {
              subject.perform(app.id, all: true)
            }.to change(Measurement::Activity, :count).by(61)
          end
        end
      end
      it "fetches 1 height measurement" do
        Timecop.freeze Time.utc(2014, 10, 2, 14, 52) do
          VCR.use_cassette "health_data_worker/fitbit/height" do
            expect {
              subject.perform(app.id, all: true)
            }.to change(Measurement::Height, :count).by(1)
          end
        end
      end
      it "fetches 1 weight measurement" do
        Timecop.freeze Time.utc(2014, 10, 2, 14, 52) do
          VCR.use_cassette "health_data_worker/fitbit/weight" do
            expect {
              subject.perform(app.id, all: true)
            }.to change(Measurement::Weight, :count).by(1)
          end
        end
      end
      it "fetches 1 profile update" do
        Timecop.freeze Time.utc(2014, 10, 2, 14, 52) do
          VCR.use_cassette "health_data_worker/fitbit/profile" do
            subject.perform(app.id, all: true)
            app.user.profile.reload
            expect(app.user.profile.birth_date).to eq("1980-08-01".to_date)
            expect(app.user.profile.sex).to eq('F')
          end
        end
      end
    end

    describe "synchronize" do
      it "fetches only new activities" do
        Timecop.freeze Time.utc(2014, 10, 2, 14, 52) do
          FactoryGirl.create :activity_measurement, user: app.user, date: 3.days.ago, timestamp: 3.days.ago
          VCR.use_cassette "health_data_worker/fitbit/synchronize" do
            expect {
              subject.perform(app.id)
            }.to change(Measurement::Activity, :count).by(4)
          end
        end
      end
    end
  end

  context "withings" do

    let(:app) { FactoryGirl.create :withings_app }

    describe "all" do
      it "fetches 1 weight measurements" do
        Timecop.freeze Time.utc(2014, 9, 30, 15, 22) do
          VCR.use_cassette "health_data_worker/withings/all", match_requests_on: [:host, :path] do
            expect {
              subject.perform(app.id, all: true)
            }.to change(Measurement::Weight, :count).by(1)
          end
        end
      end

      it "fetches 3 activity measurements" do
        Timecop.freeze Time.utc(2014, 10, 2, 10, 44) do
          VCR.use_cassette "health_data_worker/withings/activity", match_requests_on: [:host, :path] do
            expect {
              subject.perform(app.id, all: true)
            }.to change(Measurement::Activity, :count).by(3)
          end
        end
      end

      it "fetches 1 height measurements" do
        Timecop.freeze Time.utc(2014, 9, 30, 15, 22) do
          VCR.use_cassette "health_data_worker/withings/height", match_requests_on: [:host, :path] do
            expect {
              subject.perform(app.id, all: true)
            }.to change(Measurement::Height, :count).by(1)
          end
        end
      end
    end

    describe "synchronize" do
      it "fetches only new activities" do
        Timecop.freeze Time.utc(2014, 9, 30, 15, 22) do
          FactoryGirl.create :weight_measurement, user: app.user, date: 1.days.ago, timestamp: 1.days.ago
          VCR.use_cassette "health_data_worker/withings/synchronize", match_requests_on: [:host, :path] do
            expect {
              subject.perform(app.id)
            }.to change(Measurement::Weight, :count).by(9)
          end
        end
      end
    end
  end

end
