class AddBucketToParseApp < ActiveRecord::Migration
  def change
    add_column :parse_apps, :bucket, :string
  end
end
