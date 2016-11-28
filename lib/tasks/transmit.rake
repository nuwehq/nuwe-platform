pg_dump='pg_dump --no-owner --format=custom'
pg_restore='pg_restore --clean --no-acl --no-owner'

namespace :transmit do
  # Download all assets from production to development environment
  task :assets do
    system "rsync -avz deploy@api.nuapi.co:/var/www/vhosts/api.nuapi.co/shared/public/system public/"
  end

  # Download the production database and put into development database
  task :database do
    puts "Dumping database on the server..."
    system "ssh deploy@api.nuapi.co '#{pg_dump} -f nuapi.pg nuapi.co'"
    system "scp deploy@api.nuapi.co:nuapi.pg ."
    system "#{pg_restore} -d nuapi_development nuapi.pg"
    File.delete "nuapi.pg"
  end

  # Copy all production data to staging
  task :staging do
    system "ssh deploy@api.nuapi.co '#{pg_dump} nuapi.co | #{pg_restore} -d staging.nuapi.co'"
    system "ssh deploy@api.nuapi.co 'rsync -avz /var/www/vhosts/api.nuapi.co/shared/system /var/www/vhosts/staging.nuapi.co/shared'"
  end
end
