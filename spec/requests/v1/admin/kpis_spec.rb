require "rails_helper"

RSpec.describe "Admin KPIs as non-admin" do

  include_context "signed up user"
  include_context "api token authentication"

  it_behaves_like "an authenticated resource" do
    before do
      get "/v1/admin/kpis", nil, token_auth
    end
  end

end

RSpec.describe "Admin KPIs" do

  include_context "signed up admin"
  include_context "api token authentication"

  it_behaves_like "an authenticated resource" do
    before do
      get "/v1/admin/kpis"
    end
  end

  describe "users" do
    it "returns new users" do
      FactoryGirl.create_list :user, 3
      get "/v1/admin/kpis", nil, token_auth
      expect(json_body["kpis"]["new_users"]).to eq(3)
    end

    it "counts today by default" do
      Timecop.travel Time.utc(2014, 9, 28, 13, 00) do
        FactoryGirl.create_list :user, 6
      end
      FactoryGirl.create_list :user, 2
      get "/v1/admin/kpis", nil, token_auth
      expect(json_body["kpis"]["new_users"]).to eq(2)
    end

    it "can count users for a week" do
      Timecop.travel Time.utc(2014, 9, 30, 13, 00) do
        FactoryGirl.create_list :user, 6
      end
      get "/v1/admin/kpis?from=2014-09-29&to=2014-10-05", nil, token_auth
      expect(json_body["kpis"]["new_users"]).to eq(6)
    end
  end

  describe "teams" do
    it "returns new teams" do
      FactoryGirl.create_list :team, 3
      get "/v1/admin/kpis", nil, token_auth
      expect(json_body["kpis"]["new_teams"]).to eq(3)
    end

    it "counts today by default" do
      Timecop.travel Time.utc(2014, 9, 28, 13, 00) do
        FactoryGirl.create_list :team, 6
      end
      FactoryGirl.create_list :team, 2
      get "/v1/admin/kpis", nil, token_auth
      expect(json_body["kpis"]["new_teams"]).to eq(2)
    end

    it "can count teams for a week" do
      Timecop.travel Time.utc(2014, 9, 30, 13, 00) do
        FactoryGirl.create_list :team, 6
      end
      get "/v1/admin/kpis?from=2014-09-29&to=2014-10-05", nil, token_auth
      expect(json_body["kpis"]["new_teams"]).to eq(6)
    end
  end

  describe "notifications" do
    it "returns notifications created" do
      FactoryGirl.create_list :team_notification, 3
      get "/v1/admin/kpis", nil, token_auth
      expect(json_body["kpis"]["notifications"]).to eq(3)
    end

    it "counts today by default" do
      Timecop.travel Time.utc(2014, 9, 28, 13, 00) do
        FactoryGirl.create_list :team_notification, 6
      end
      FactoryGirl.create_list :team_notification, 2
      get "/v1/admin/kpis", nil, token_auth
      expect(json_body["kpis"]["notifications"]).to eq(2)
    end

    it "can count notification for a week" do
      Timecop.travel Time.utc(2014, 9, 30, 13, 00) do
        FactoryGirl.create_list :team_notification, 6
      end
      get "/v1/admin/kpis?from=2014-09-29&to=2014-10-05", nil, token_auth
      expect(json_body["kpis"]["notifications"]).to eq(6)
    end
  end

  describe "invitations" do
    it "returns invitations created" do
      FactoryGirl.create_list :invitation, 3
      get "/v1/admin/kpis", nil, token_auth
      expect(json_body["kpis"]["invitations"]).to eq(3)
    end

    it "counts today by default" do
      Timecop.travel Time.utc(2014, 9, 28, 13, 00) do
        FactoryGirl.create_list :invitation, 6
      end
      FactoryGirl.create_list :invitation, 2
      get "/v1/admin/kpis", nil, token_auth
      expect(json_body["kpis"]["invitations"]).to eq(2)
    end

    it "can count invitation for a week" do
      Timecop.travel Time.utc(2014, 9, 30, 13, 00) do
        FactoryGirl.create_list :invitation, 6
      end
      get "/v1/admin/kpis?from=2014-09-29&to=2014-10-05", nil, token_auth
      expect(json_body["kpis"]["invitations"]).to eq(6)
    end
  end
end
