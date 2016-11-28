class AddComingSoonToServices < ActiveRecord::Migration
  def change
    add_column :services, :coming_soon, :boolean, default: false
    execute "update services set coming_soon = 't' where name = 'Prediction.IO'"
  end
end
