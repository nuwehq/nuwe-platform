class ChangeMeasurementsColumnUsers < ActiveRecord::Migration
  def up
    remove_column :users, :measurements
    add_column :users, :measurements, :hstore, default: {}, null: false

    User.find_each do |user|
      user.measurements['step'] = user.last_step_measurement.value unless user.step_measurements.empty?
      user.measurements['blood_pressure'] = user.last_blood_pressure_measurement.value unless user.blood_pressure_measurements.empty?
      user.measurements['bmi'] = user.last_bmi_measurement.value unless user.bmi_measurements.empty?
      user.measurements['bpm'] = user.last_bpm_measurement.value unless user.bpm_measurements.empty?
      user.measurements['height'] = user.last_height_measurement.value unless user.height_measurements.empty?
      user.measurements['weight'] = user.last_weight_measurement.value unless user.weight_measurements.empty?
      user.save
    end
  end

  def down
    remove_column :users, :measurements
    add_column :users, :measurements, :text, default: '{}', null: false

    User.find_each do |user|
      user.measurements['step'] = user.last_step_measurement.value unless user.step_measurements.empty?
      user.measurements['blood_pressure'] = user.last_blood_pressure_measurement.value unless user.blood_pressure_measurements.empty?
      user.measurements['bmi'] = user.last_bmi_measurement.value unless user.bmi_measurements.empty?
      user.measurements['bpm'] = user.last_bpm_measurement.value unless user.bpm_measurements.empty?
      user.measurements['height'] = user.last_height_measurement.value unless user.height_measurements.empty?
      user.measurements['weight'] = user.last_weight_measurement.value unless user.weight_measurements.empty?
      user.save
    end
  end
end
