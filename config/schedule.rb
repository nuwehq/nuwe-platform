# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
#
# Learn more: http://github.com/javan/whenever

env :PATH, '/usr/local/bin:/usr/bin:$PATH'

set :output, 'log/cron.log'

every 1.hour do
  rake "limit_counter:create"
end

every 5.hours do
  rake "measurements:apps:synchronize"
end

every 1.day, :at => '12:02am' do
  rake "user_historical_scores:create"

  # at the end, ping the dead man's snitch
  command "curl https://nosnch.in/46e861c7a1 &> /dev/null"
end


every 1.day, :at => '01:02am' do
  rake "historical_scores:teams"

  rake "teams:achievements"
end

every 1.day, :at => '01:55am' do
  rake "measurements:yesterday"
end
