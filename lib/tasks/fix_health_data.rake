namespace :fix_health_data do

  desc "Add health data preferences to users who don't have them yet"
  task :preferences => :environment do

    User.find_each do |user|
      if user.preferences.where(name: "use_health_data").empty?
        user.preferences.create! name: "use_health_data", value: "true"
        puts "Created preferences for #{user.email}"
      end
    end

  end

end
