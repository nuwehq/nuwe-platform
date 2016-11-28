role :app, %w{deploy@api.nuapi.co}
role :web, %w{deploy@api.nuapi.co}
role :db,  %w{deploy@api.nuapi.co}

set :deploy_to, '/var/www/vhosts/api.nuapi.co'
