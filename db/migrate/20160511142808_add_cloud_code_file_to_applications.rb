class AddCloudCodeFileToApplications < ActiveRecord::Migration
  def change
    add_attachment :oauth_applications, :cloud_code_file
  end
end
