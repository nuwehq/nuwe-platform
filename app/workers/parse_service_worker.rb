# perform creates new Docker container on the Nuwe Parse App by adjusting the Service.yml
class ParseServiceWorker
  include Sidekiq::Worker

  def initialize(oauth_application)
    @application = Doorkeeper::Application.find oauth_application.id
    @parse_app = @application.parse_app
  end

  attr_reader :old_service_yaml, :new_service_yaml

  def perform
    populate_yml_fields
    get_current_service_yaml
    add_new_parse_to_yaml
    send_service_yaml_to_stack
    redeploy_stack
  end

  def update_env_vars
    populate_yml_fields
    get_current_service_yaml
    update_notification_credentials
    send_service_yaml_to_stack
    redeploy_stack
  end

  # all the env variables in C66's service_yaml need to be populated, or else it breaks
  def populate_yml_fields
    if @application.apns_certificate.present?
      @ios_certificate_url = @application.apns_certificate.url
    else
      @ios_certificate_url = "/system/doorkeeper/applications/apns_certificates/000/000/199/original/test.pem?1459936745"
    end
    @ios_certificate_file_name  = @application.apns_certificate_file_name.presence || "test.pem"
    @ios_bundle_id              = @application.notification_bundleid.presence || "com.Myapp.parse"
    @ios_in_production          = @application.notification_production.presence || false
    @gcm_sender_id              = @application.gcm_sender_id.presence || "test_string"
    @gcm_api_key                = @application.gcm_api_key.presence || "test_string"
    @cloud_code_file            = @application.cloud_code_file.presence || "/system/doorkeeper/applications/cloud_code_files/000/000/198/original/cloud.js?1463732859"
    @mailgun_api_key            = @application.mailgun_api_key.presence || "test_string"
    @mailgun_domain             = @application.mailgun_domain.presence || "test_string"
    @mailgun_from_address       = @application.mailgun_from_address || "test_string"
  end

  def get_current_service_yaml
    response = ConnectParseServiceYaml.new(nil, nil).yaml_commits
    page = response["pagination"]["pages"]

    paginated_response = ConnectParseServiceYaml.new(nil, page).yaml_commits_paginated
    final_commit = paginated_response["response"][-1]

    result = ConnectParseServiceYaml.new(final_commit["uid"], nil).last_commit
    @old_service_yaml = result["response"]["body"]
  end

  def add_new_parse_to_yaml
    new_parse_server = "  parse-#{@application.id}:\n    git_url: git@github.com:nuwehq/nuwe-parse-server.git\n    git_branch: master\n    ports:\n    - container: 1337\n      https: #{@parse_app.port}\n    env_vars:\n      MONGODB_URL: mongodb://_env(MONGODB_ADDRESS_INT):27017/nuwe_parse_#{@application.id}\n      APP_ID: #{@parse_app.app_id}\n      MASTER_KEY: #{@parse_app.master_key}\n      BUCKET_NAME: #{@parse_app.bucket}\n      CERTIFICATE_URI: https://developer.nuwe.co#{@ios_certificate_url}\n      CERTIFICATE_NAME: #{@ios_certificate_file_name}\n      BUNDLE_ID: #{@ios_bundle_id}\n      NOTIFICATION_PRODUCTION: #{@ios_in_production}\n      GCM_SENDER_ID: #{@gcm_sender_id}\n      GCM_API_KEY: #{@gcm_api_key}\n      CLOUD_CODE_FILE: https://developer.nuwe.co#{@cloud_code_file} \n      SERVER_URL: https://parse.nuwe.co:#{@parse_app.port}/parse \n      MAILGUN_API_KEY: #{@mailgun_api_key} \n      MAILGUN_DOMAIN: #{@mailgun_domain} \n      MAILGUN_FROM_ADDRESS: #{@mailgun_from_address}\n"
    @new_service_yaml = @old_service_yaml.gsub(/(?=(database))/, new_parse_server)
  end

  def update_notification_credentials
    service = YAML.load(old_service_yaml) || {"services" => {}}
    service["services"]["parse-#{@application.id}"] ||= {"env_vars" => {}}
    service["services"]["parse-#{@application.id}"]["env_vars"]["CERTIFICATE_URI"] = "https://developer.nuwe.co#{@ios_certificate_url}"
    service["services"]["parse-#{@application.id}"]["env_vars"]["CERTIFICATE_NAME"] = @ios_certificate_file_name
    service["services"]["parse-#{@application.id}"]["env_vars"]["BUNDLE_ID"] = @ios_bundle_id
    service["services"]["parse-#{@application.id}"]["env_vars"]["NOTIFICATION_PRODUCTION"] = @ios_in_production
    service["services"]["parse-#{@application.id}"]["env_vars"]["GCM_SENDER_ID"] = @gcm_sender_id
    service["services"]["parse-#{@application.id}"]["env_vars"]["GCM_API_KEY"] = @gcm_api_key
    service["services"]["parse-#{@application.id}"]["env_vars"]["CLOUD_CODE_FILE"] = "https://developer.nuwe.co#{@cloud_code_file}"
    service["services"]["parse-#{@application.id}"]["env_vars"]["MAILGUN_API_KEY"] = @mailgun_api_key
    service["services"]["parse-#{@application.id}"]["env_vars"]["MAILGUN_DOMAIN"] = @mailgun_domain
    service["services"]["parse-#{@application.id}"]["env_vars"]["MAILGUN_FROM_ADDRESS"] = @mailgun_from_address
    @new_service_yaml = YAML.dump(service)
  end

  def send_service_yaml_to_stack
    HTTParty.post("https://app.cloud66.com/api/3/stacks/3b4f442463ed48e92d94b0783f689f81/service_yaml.json",
    :body => { :service_yaml => "#{@new_service_yaml}",
              :comments => "Adds parse server parse-#{@application.id}\n"}.to_json,
    :headers => {"Content-Type" => 'application/json', "Authorization" => "Bearer #{ENV['CLOUD66_BEARER']}"})
  end

  def redeploy_stack
    HTTParty.post("https://app.cloud66.com/api/3/stacks/3b4f442463ed48e92d94b0783f689f81/deployments.json",
    :headers => {"Content-Type" => 'application/json', "Authorization" => "Bearer #{ENV['CLOUD66_BEARER']}"},
    :query   => { "services" => ["parse-#{@application.id}"]})
  end
end
