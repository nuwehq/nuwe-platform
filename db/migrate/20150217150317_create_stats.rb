class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.references :oauth_application, index: true
      t.datetime :log_time
      t.string :resource_owner
      t.string :request

      t.timestamps
    end
  end
end
