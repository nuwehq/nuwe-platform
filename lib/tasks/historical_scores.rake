namespace :historical_scores do

  desc "Store historical score for teams"
  task teams: :environment do
    Team.find_each do |team|
      historical_score = team.historical_scores.find_or_initialize_by(date: Date.yesterday)
      historical_score.activity = team.activity_score
      historical_score.nutrition = team.nutrition_score
      historical_score.biometric = team.biometric_score
      historical_score.nu = team.nu_score
      historical_score.save!
      puts "Stored historical score for #{team.name}"
    end
  end

end
