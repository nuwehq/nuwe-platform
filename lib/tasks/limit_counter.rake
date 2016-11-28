namespace :limit_counter do

  desc "Count user limits on Doorkeeper Applications"
  task :create => :environment do

    Doorkeeper::Application.find_each do |application|
      if application.valid_purchase?
        if application.resource_owners.count > application.subscriptions.last.user_limit
          application.update_attribute(:user_limit, true)
          LimitMailer.limit_reached(application, "user limit").deliver_later
        end
        if application.stats.where("log_time > ?", 30.days.ago).count > application.subscriptions.last.api_call_limit
          application.update_attribute(:request_limit, true)
          LimitMailer.limit_reached(application, "request limit").deliver_later
        end
      end
    end
  end
end