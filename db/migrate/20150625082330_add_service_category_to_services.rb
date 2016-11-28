class AddServiceCategoryToServices < ActiveRecord::Migration
  def change
    add_reference :services, :service_category, index: true
  end
end
