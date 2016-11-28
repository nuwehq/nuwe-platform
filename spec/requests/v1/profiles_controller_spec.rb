require 'rails_helper'

describe V1::ProfilesController do

  include_context "signed up user"
  include_context "api token authentication"

  describe "show" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile
    end

    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/profile.json"
      end
    end

    it "returns status 200" do
      get "/v1/profile.json", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "contains the user profile" do
      get "/v1/profile.json", nil, token_auth
      expect(json_body["user"]).to be_present
      expect(json_body["user"]["profile"]).to be_present
    end

    it "contains preferences" do
      user.preferences.destroy_all
      FactoryGirl.create :units_preference, user: user
      get "/v1/profile.json", nil, token_auth
      expect(json_body["user"]["preferences"]).to eq([{"name" => "units", "value" => "imperial"}])
    end

    %w(height weight bmi bpm blood_pressure).each do |type|
      it "contains a #{type} measurement" do
        measurement = FactoryGirl.create "#{type}_measurement", user: user
        get "/v1/profile.json", nil, token_auth
        expect(json_body["user"][type]).to be_present
        expect(json_body["user"][type]).to eq(measurement.value.to_s)
      end
    end

    context "avatar" do
      before do
        user.profile.update_attribute :avatar, File.open('spec/uploads/avatar.jpg')
      end

      %w(tiny small medium).each do |style|
        it "contains a #{style} thumbnail" do
          get "/v1/profile.json", nil, token_auth
          expect(json_body["user"]["profile"]["avatar"][style]).to include(user.profile.avatar.url(style))
        end
      end
    end
  end

  describe "show gda" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile_giulia
      Nu::Score.new(user).daily_scores(Date.current)
    end

    it "returns status 200" do
      get "/v1/profile.json", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "contains the correct values" do
      get "/v1/profile.json", nil, token_auth
      expect(json_body["user"]["nutrition"]["personalised_gda"]["fibre"]["g"]).to be(24)
    end
  end

  describe "show gda for female" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile_giulia
      Nu::Score.new(user).daily_scores(Date.current)
    end

    it "returns status 200" do
      get "/v1/profile.json", nil, token_auth
      expect(response.status).to eq(200)
    end

    it "contains the correct values" do
      get "/v1/profile.json", nil, token_auth
      expect(json_body["user"]["nutrition"]["personalised_gda"]["carbs"]["kcal"]).to eq(792.5586999999999)

      be_within(0.1).of(41.11)
    end
  end

  describe "show proper response with no dcn value" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile
    end

    it "returns the correct hash" do
      get "/v1/profile.json", nil, token_auth
      expect(json_body["user"]["nutrition"]).to be_present
    end
  end

  describe "initial profile" do
    before do

      patch "/v1/profile.json", {
        profile: {
          birth_date: "1991-11-11",
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          sex: ['M', 'F'].sample,
          height: 1920,
          weight: 88000
        }
      }, token_auth
    end

    it "creates personalised GDA" do
      expect(json_body["user"]["nutrition"]["personalised_gda"]).to be_present
    end


  end


  describe "update" do
    before do
      user.profile.update FactoryGirl.attributes_for :profile
    end
    it_behaves_like "an authenticated resource" do
      before do
        patch "/v1/profile.json"
      end
    end

    it_behaves_like "a correctly formatted token" do
      before do
        patch "/v1/profile.json", nil, invalid_token_auth
      end
    end

    describe "complete request" do

      before do

        patch "/v1/profile.json", {
          profile: {
            birth_date: "1975-09-16",
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            sex: ['M', 'F'].sample,
            activity: [1, 2, 3, 4, 5].sample,
            height: 1900,
            weight: 83000,
            bpm: 120,
            blood_pressure: "120/50",
            time_zone: "Europe/Sofia"
          }
        }, token_auth

      end

      let(:profile) { user.reload.profile }

      it "creates the profile if nessesary" do
        expect(user.reload.profile).to_not be_nil
      end

      it "contains biometric score" do
        expect(json_body["user"]["biometric_score"]).to be_present
      end

      it "updates profile information" do
        expect(profile.birth_date).to eq("1975-09-16".to_date)
      end

      it "creates a weight measurement" do
        expect(user.reload.weight).to be_present
      end

      it "creates a height measurement" do
        expect(user.reload.height).to be_present
      end

      it "creates a bpm measurement" do
        expect(user.reload.bpm).to be_present
      end

      it "creates a blood pressure measurement" do
        expect(user.reload.blood_pressure).to be_present
      end

      it "stores the time zone" do
        expect(profile.reload.time_zone).to eq("Europe/Sofia")
      end
    end

    describe "height and weight" do

      it "stores both values" do
        patch "/v1/profile.json", {profile: {height: 1800, weight: 80000}}, token_auth
        expect(BigDecimal.new(json_body["user"]["height"])).to eq(1800)
        expect(BigDecimal.new(json_body["user"]["weight"])).to eq(80000)
      end

    end

    context "preferences" do

      it "stores units" do
        patch "/v1/profile.json", {
          profile: {
            units: "imperial"
          }
        }, token_auth
        expect(user.preferences.find_by(name: "units").value).to eq("imperial")
      end

      it "stores health data" do
        patch "/v1/profile.json", {
          profile: {
            use_health_data: "false"
          }
        }, token_auth
        expect(user.preferences.find_by(name: "use_health_data").value).to eq("false")
      end

    end

    context "avatar" do

      def base64_avatar
        base64 = Base64.encode64(File.read('spec/uploads/avatar.jpg'))
        "data:image/jpeg;base64,#{base64}"
      end

      it "stores the jpg" do
        patch "/v1/profile.json", {
          profile: {
            avatar: base64_avatar
          }
        }, token_auth
        expect(user.reload.profile.avatar).to exist
      end
    end

    context "missing profile key" do
      it "reports an error" do
        patch "/v1/profile.json", nil, token_auth
        expect(response.status).to eq(400)

        expect(json_body["error"]["message"]).to_not be_nil
      end
    end

    context "with DCN" do

      it "contains nutrition score" do
        patch "/v1/profile.json", { profile: { bpm: 100 } }, token_auth
        expect(json_body["user"]["nutrition"]).to be_present
      end
    end

  end

  describe "destroy" do
    it "remove user profile and return ok" do
      delete "/v1/profile.json", nil, token_auth
      profile = Profile.where(user_id: user.id).first
      expect(profile).to be_nil
      expect(response.status).to eq(200)
    end
  end

end
