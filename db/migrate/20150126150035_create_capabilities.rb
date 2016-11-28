class CreateCapabilities < ActiveRecord::Migration
  def change
    create_table :capabilities do |t|
      t.belongs_to :service, index: true
      t.belongs_to :application, index: true
      t.timestamps
    end
  end
end
