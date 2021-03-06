require 'rails_helper'

describe V1::AppsController do

  include_context "signed up user"
  include_context "api token authentication"

  describe "index" do
    it_behaves_like "an authenticated resource" do
      before do
        get "/v1/apps.json"
      end
    end

    def do_get
      get "/v1/apps.json", nil, token_auth
    end

    %w(nutrition activity biometric).each do |category|
      it "has a #{category} category" do
        do_get
        expect(json_body["apps"][category]).to be_present
      end
    end

    describe "nutrition" do
      %w(nutribu).each do |provider|
        it "contains #{provider} app" do
          do_get
          expect(json_body["apps"]["nutrition"].map {|app| app["provider"]}).to include(provider)
        end

        %w(name description icon).each do |field|
          it "has a #{field} field" do
            do_get
            app = json_body["apps"]["nutrition"].find {|app| app["provider"] == provider}
            expect(app[field]).to be_present
          end
        end

        describe "with #{provider} connected" do
          before do
            FactoryGirl.create :app, provider: provider, user: user
          end

          it "shows #{provider} as connected" do
            do_get
            app = json_body["apps"]["nutrition"].find {|app| app["provider"] == provider}
            expect(app["connected"]).to be_truthy
          end
        end
      end
    end

    describe "activity" do
      %w(withings moves fitbit humanapi).each do |provider|
        it "contains #{provider} app" do
          do_get
          expect(json_body["apps"]["activity"].map {|app| app["provider"]}).to include(provider)
        end

        describe "with #{provider} connected" do
          before do
            FactoryGirl.create :app, provider: provider, user: user
          end

          it "shows #{provider} as connected" do
            do_get
            app = json_body["apps"]["activity"].find {|app| app["provider"] == provider}
            expect(app["connected"]).to be_truthy
          end

          it "has connected apps first" do
            do_get
            expect(json_body["apps"]["activity"].first["provider"]).to eq(provider)
          end
        end
      end

      it "allows apps to be ordered" do
        fitbit = FactoryGirl.create :app, provider: "fitbit", user: user, position: 3
        withings = FactoryGirl.create :app, provider: "withings", user: user, position: 1
        do_get
        expect(json_body["apps"]["activity"].first["provider"]).to eq("withings")
        expect(json_body["apps"]["activity"].second["provider"]).to eq("fitbit")
      end
    end

    describe "biometric" do
      %w(withings humanapi).each do |provider|
        it "contains #{provider} app" do
          do_get
          expect(json_body["apps"]["biometric"].map {|app| app["provider"]}).to include(provider)
        end

        describe "with #{provider} connected" do
          before do
            FactoryGirl.create :app, provider: provider, user: user
          end

          it "shows #{provider} as connected" do
            do_get
            app = json_body["apps"]["biometric"].find {|app| app["provider"] == provider}
            expect(app["connected"]).to be_truthy
          end

          it "has connected apps first" do
            do_get
            expect(json_body["apps"]["activity"].first["provider"]).to eq(provider)
          end
        end
      end

      it "allows apps to be ordered" do
        withings = FactoryGirl.create :app, provider: "withings", user: user, position: 6
        humanapi = FactoryGirl.create :app, provider: "humanapi", user: user, position: 1
        do_get
        expect(json_body["apps"]["activity"].first["provider"]).to eq("humanapi")
        expect(json_body["apps"]["activity"].second["provider"]).to eq("withings")
      end
    end

  end

  describe "update" do
    let!(:smurf) { FactoryGirl.create :app, provider: "withings", user: user }

    it_behaves_like "an authenticated resource" do
      before do
        patch "/v1/apps/withings.json"
      end
    end

    it_behaves_like "a nice 404 response" do
      before do
        patch "/v1/apps/teamsnowden.json", nil, token_auth
      end
    end

    it "allows position to be changed" do
      patch "/v1/apps/withings.json", {app: {position: 12}}, token_auth
      expect(smurf.reload.position).to eq(12)
    end

    it "only allows position to be changed" do
      patch "/v1/apps/withings.json", {app: {provider: "bobby_tables"}}, token_auth
      expect(smurf.reload.provider).to eq("withings")
    end
  end

  describe "destroy" do
    let!(:smurf) { FactoryGirl.create :app, provider: "withings", user: user }

    it_behaves_like "an authenticated resource" do
      before do
        delete "/v1/apps/withings.json"
      end
    end

    it "removes the app" do
      delete "/v1/apps/withings.json", nil, token_auth
      expect(user.apps.map(&:provider)).to_not include("withings")
    end

    it "lists the app as not connected" do
      delete "/v1/apps/withings.json", nil, token_auth
      app = json_body["apps"]["biometric"].find {|app| app["provider"] == "withings"}
      expect(app["connected"]).to be_falsy
    end
  end

end
