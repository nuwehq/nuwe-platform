class DropBmiPrimeLookups < ActiveRecord::Migration
  def change
    drop_table :nu_bmi_prime_lookups
  end
end
