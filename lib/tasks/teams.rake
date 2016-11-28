namespace :teams do

  desc "Create achievements due"
  task :achievements => :environment do
    Team.find_each do |team|

      progress = TeamProgress.new(team)

      progress.milestones
      progress.streaks
      progress.goals
      progress.hiscores
      puts "Achievements for #{team.name} created"
    end
  end

end
