class CreateNuNutritions < ActiveRecord::Migration
  def change
    create_table :nu_nutritions do |t|
      t.references :user, index: true, null: false
      t.integer :score
      t.date :date, null: false
      t.foreign_key :users, dependent: :delete
      t.timestamps
    end
  end
end
