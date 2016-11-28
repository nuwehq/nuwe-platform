class StatJob < ActiveJob::Base
  queue_as :default
 
  def perform(application_id, log_time, resource_owner, request)
    Stat.create!(application_id: application_id, log_time: Time.at(log_time), resource_owner: resource_owner, request: request)
  end
end
