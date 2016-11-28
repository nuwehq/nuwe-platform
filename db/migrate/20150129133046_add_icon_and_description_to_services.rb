class AddIconAndDescriptionToServices < ActiveRecord::Migration
  def change
    add_attachment :services, :icon
    add_column :services, :description, :text
  end
end
