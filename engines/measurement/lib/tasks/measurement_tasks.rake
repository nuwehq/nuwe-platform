namespace :measurements do

  namespace :apps do
    desc "Synchronize new measurements from all app sources"
    task synchronize: :environment do
      App.find_each do |app|
        puts app.id
        puts app.provider
        HealthDataWorker.new.perform(app.id)
        puts app.id
      end
    end
  end

  desc "Get yesterday's measurements for every user"
  task :yesterday => :environment do
    # Calculate all resulting scores for everyone
    # TODO this code is duplicated with HealthDataWorker
    # where it is used in the context of historical readings for a newly
    # connected app, where in here it is used to fetch new records for
    # the past day. Must find a way to combine this neatly.
    User.find_each do |user|
      Measurement::BmrCalculator.calculate(user, Date.yesterday)
      Nu::Score.new(user).daily_scores(Date.yesterday)
      Measurement::DcnCalculator.calculate(user, Date.yesterday)
    end

  end
end