role :app, %w{deploy@staging.nuapi.co}
role :web, %w{deploy@staging.nuapi.co}
role :db,  %w{deploy@staging.nuapi.co}

set :deploy_to, '/var/www/vhosts/staging.nuapi.co'
