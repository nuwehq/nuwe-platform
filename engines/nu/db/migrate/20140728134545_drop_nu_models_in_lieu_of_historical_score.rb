class DropNuModelsInLieuOfHistoricalScore < ActiveRecord::Migration
  def change
    drop_table :nu_activities
    drop_table :nu_biometrics
    drop_table :nu_nutritions
  end
end
