namespace :example_mail do

  desc "Remove example mail addresses which were added for test purposes"
  task :delete => :environment do

    User.find_each do |user|
      if user.email.include?("@example.com")
        unless user.email == "gorby@example.com"
          user.destroy!
          puts "Deleted #{user.email}"
        end
      end
    end


  end
end