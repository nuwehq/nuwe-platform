class MedicalDeviceUploader::AddColumns
  include Interactor

  delegate :medical_device, to: :context

  def call
    if context.upload.upload_action == "rep-parser"
      if medical_device.column_values.present?
        medical_device.column_values.destroy_all
      end
      columns_info.each do |column|
        value = medical_device.column_values.new
        column.each do |k,v|
          value[k] = v
        end
        value.save!
      end
    end
  end

  def columns_info
    [].tap do |info|
      info << {:field_name=>"measurement_magnetic_intensity",:type=>"integer",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"measurement_laser_power_dac",:type=>"integer",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"speed_profile_parameters",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"loop1_first_lock_in_time",:type=>"integer",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"loop1_temperature_sensor_value1",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"loop1_temperature_sensor_value2",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"loop2_first_lock_in_time",:type=>"integer",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"loop2_temperature_sensor_value1",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"loop2_temperature_sensor_value2",:type=>"float",:read_only=>false,:editor=>"text"}

      0.upto(20) do |n|
        info << {:field_name=>"lock_in_frequency_f#{n}",:type=>"integer",:read_only=>false,:editor=>"text"}
        info << {:field_name=>"loop1_data_real_#{n}",:type=>"integer",:read_only=>false,:editor=>"text"}
        info << {:field_name=>"loop1_data_imag_#{n}",:type=>"integer",:read_only=>false,:editor=>"text"}
        info << {:field_name=>"loop1_v0_#{n}",:type=>"integer",:read_only=>false,:editor=>"text"}
        info << {:field_name=>"loop2_data_real_#{n}",:type=>"integer",:read_only=>false,:editor=>"text"}
        info << {:field_name=>"loop2_data_imag_#{n}",:type=>"integer",:read_only=>false,:editor=>"text"}
        info << {:field_name=>"loop2_v0_#{n}",:type=>"integer",:read_only=>false,:editor=>"text"}
      end

      info << {:field_name=>"error_code",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"total_executing_time",:type=>"integer",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"concentration",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"disc_id",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"disc_manufacture_date",:type=>"string",:read_only=>true,:editor=>"datePicker"}
      info << {:field_name=>"expiration_days",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"disc_factory_id",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"disc_line_numbers",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"disc_lot_numbers",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"curve_parameter_a",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"curve_parameter_b",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"curve_parameter_c",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"curve_parameter_d",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"curve_parameter_e",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"curve_parameter_f",:type=>"float",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"machine_id",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"machine_factory_id",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"machine_line_numbers",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"model_id",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"h_w_id",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"mtk_firmware_version",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"micro_chip_firmware_version",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"app_software_version",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"win_ap_version",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"operator_id",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"bio_diagnostics_date",:type=>"datetime",:read_only=>false,:editor=>"datetimePicker"}
      info << {:field_name=>"bio_diagnostics_item",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"user_email",:type=>"string",:read_only=>false,:editor=>"text"}
      info << {:field_name=>"user_id",:type=>"string",:read_only=>false,:editor=>"text"}
    end
  end

end
