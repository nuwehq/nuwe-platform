require 'rails_helper'

describe ParseServiceWorker do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:parse_app) { FactoryGirl.create :parse_app, application: oauth_application }

  describe "add_new_parse_to_yaml" do
    it "updates the service.yaml" do
      result = ParseServiceWorker.new(oauth_application)
      result.instance_variable_set("@old_service_yaml", "database")
      test_result = result.add_new_parse_to_yaml
      expect(test_result).to eq("  parse-#{oauth_application.id}:\n    git_url: git@github.com:nuwehq/nuwe-parse-server.git\n    git_branch: master\n    ports:\n    - container: 1337\n      https: \n    env_vars:\n      MONGODB_URL: mongodb://_env(MONGODB_ADDRESS_INT):27017/nuwe_parse_#{oauth_application.id}\n      APP_ID: #{oauth_application.parse_app.app_id}\n      MASTER_KEY: #{oauth_application.parse_app.master_key}\n      BUCKET_NAME: \n      CERTIFICATE_URI: https://developer.nuwe.co\n      CERTIFICATE_NAME: \n      BUNDLE_ID: \n      NOTIFICATION_PRODUCTION: \n      GCM_SENDER_ID: \n      GCM_API_KEY: \n      CLOUD_CODE_FILE: https://developer.nuwe.co \n      SERVER_URL: https://parse.nuwe.co:/parse \n      MAILGUN_API_KEY:  \n      MAILGUN_DOMAIN:  \n      MAILGUN_FROM_ADDRESS: \ndatabase")
    end
  end

  describe "update_env_vars" do
    before do
      oauth_application.update_column :id, 143 # hard coded in the VCR response

      stub_request(:post, "https://app.cloud66.com/api/3/stacks/3b4f442463ed48e92d94b0783f689f81/service_yaml.json")
      stub_request(:post, "https://app.cloud66.com/api/3/stacks/3b4f442463ed48e92d94b0783f689f81/deployments.json?services%5B%5D=parse-143")
    end

    let(:worker) do
      VCR.use_cassette "parse_service_worker/send_cloud_code" do
        w = ParseServiceWorker.new(oauth_application)
        w.update_env_vars
        w
      end
    end

    it "gets the current service.yml" do
      old_service_yaml = File.read("spec/uploads/old_service.yml")
      expect(worker.old_service_yaml).to eq(old_service_yaml)
    end

    it "inserts cloud code into the service.yml" do
      new_service_yaml = File.read("spec/uploads/cloud_code_service.yml")
      expect(worker.new_service_yaml).to eq(new_service_yaml)
    end
  end
end
