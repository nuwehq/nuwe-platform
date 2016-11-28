require 'httparty'

class ConnectParseServiceYaml

  include HTTParty

  base_uri 'https://app.cloud66.com/api/3/stacks/STACKID'

  def initialize(last_commit_uid, page)
    @last_commit_uid = last_commit_uid
    @page = page
  end

  def yaml_commits
    self.class.get("/service_yaml.json", headers)
  end

  def yaml_commits_paginated
    self.class.get("/service_yaml.json?page=#{@page}", headers)
  end

  def last_commit
    self.class.get("/service_yaml/#{@last_commit_uid}.json", headers)
  end

  private

  def headers
    {
      headers: {"Content-Type" => 'application/json', "Authorization" => "Bearer #{ENV['CLOUD66_BEARER']}"}
    }
  end

end
