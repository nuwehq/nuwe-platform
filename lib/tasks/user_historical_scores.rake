namespace :user_historical_scores do

  desc "Create historical scores for users so that laf and dcn can be calculated"
  task :create => :environment do

    User.find_each do |user|
      Measurement::HistoricalWorker.new(user, start_date=3.days.ago.to_date, end_date=Date.current).perform
      puts "Historical scores created for #{user.email}"
    end

  end

end
