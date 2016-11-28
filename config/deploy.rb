# config valid only for Capistrano 3.3.5
lock '3.3.5'

set :application,       'YOUR_APPLICATION_URL'
set :repo_url,          'YOUR_REPO_URL'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{.env config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log public/assets public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Build and deploy the Slate documentation'
  task :docs do
    # TODO write this task for easy api dox deployment.
    # in slate directory:
    #   bundle exec middleman build
    #   rsync -avzP build/ deploy@api.nuapi.co:/var/www/vhosts/api.nuapi.co/shared/public/v1/
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
