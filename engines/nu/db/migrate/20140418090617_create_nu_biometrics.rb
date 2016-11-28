class CreateNuBiometrics < ActiveRecord::Migration
  def change
    create_table :nu_biometrics do |t|
      t.integer :score
      t.date :date,             null: false
      t.belongs_to :user
      t.timestamps
    end
  end
end
