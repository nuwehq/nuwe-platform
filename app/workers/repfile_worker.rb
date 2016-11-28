require 'open-uri'
# Parse the data from an uploaded repfile to a Device Result
class RepfileWorker
  include Sidekiq::Worker

  KEYS_TO_CHAR =  [:speed_profile_parameters, :error_code, :disc_id, :disc_manufacture_date,
                  :expiration_days, :disc_factory_id, :disc_line_numbers, :disc_lot_numbers, :machine_id, :machine_factory_id,
                  :machine_line_numbers, :model_id, :h_w_id, :mtk_firmware_version, :micro_chip_firmware_version,
                  :app_software_version, :win_ap_version, :operator_id, :bio_diagnostics_item, :bio_diagnostics_date, :bio_diagnostics_time]
  KEYS_TO_DEG =   [:loop1_temperature_sensor_value1, :loop1_temperature_sensor_value2, :loop2_temperature_sensor_value1, :loop2_temperature_sensor_value2]
  KEYS_TO_FLOAT = [:concentration, :curve_parameter_a, :curve_parameter_b, :curve_parameter_c,
                  :curve_parameter_d, :curve_parameter_e, :curve_parameter_f]
  KEYS_TO_USER =  [:user_id]

  def initialize(device_file, medical_device)
    @file = device_file
    @medical_device = medical_device
    @data = {}
  end

  def perform
    1.upto(185) do |row|
      info = {get_key(row)=> get_value(row)}
      @data.merge! info
    end

    new_date = bio_diagnostics_date_time(@data[:bio_diagnostics_date], @data[:bio_diagnostics_time])
    add_date = {:bio_diagnostics_date=> new_date}
    @data.merge! add_date

    @device_result = DeviceResult.new(filename: @file.original_filename, data: @data, medical_device_id: @medical_device.id)
    @device_result.save!

  end

  def get_key(line_number)
    file = File.open(@file.path)
    column = file.each_line.take(line_number).last.scan(/(.*)(?=,)/).join.to_s
    column.parameterize.underscore.to_sym
  end

  def get_value(line_number)
    key = get_key(line_number)
    file = File.open(@file.path)
    value = file.each_line.take(line_number).last.scan(/(?<=,)\S+/).join.to_s
    if KEYS_TO_CHAR.include?(key)
      grab_last_characters(line_number)
    elsif KEYS_TO_DEG.include?(key)
      grab_last_characters_degrees(line_number)
    elsif KEYS_TO_FLOAT.include?(key)
      grab_last_characters_floating_hex(line_number)
    elsif KEYS_TO_USER.include?(key)
      nuwe_user(line_number)
    else
      signed_twos_complement(value.hex, 16)
    end
  end

  def bio_diagnostics_date_time(date, time)
    DateTime.strptime(date+time, '%y%m%d%H%M%S')
  end

  def nuwe_user(line_number)
    user_email = grab_last_characters(line_number)
    get_email = {:user_email=> user_email}
    @data.merge! get_email
    user = User.where(email: user_email).first
    if user.present? && Doorkeeper::AccessGrant.where(application: @medical_device.application_id, resource_owner_id: user.id).present?
      user.id
    end
  end

  def grab_last_characters(line_number)
    file = File.open(@file.path)
    file.each_line.take(line_number).last.scan(/(?<=,)\S+/).join.to_s
  end

  def signed_twos_complement(integer_value, num_of_bits)
    length       = num_of_bits
    mid          = 2**(length-1)
    max_unsigned = 2**length
    (integer_value >= mid) ? integer_value - max_unsigned : integer_value
  end

  def grab_last_characters_floating_hex(line_number)
    file = File.open(@file.path)
    hex = file.each_line.take(line_number).last.scan(/(?<=,)\S+/).join.to_s
    f=[hex.to_i(16)].pack('L').unpack('F')[0]
  end

  def grab_last_characters_degrees(line_number)
    file = File.open(@file.path)
    hex = file.each_line.take(line_number).last.scan(/(?<=,)\S+/).join.to_s
    int = (hex).to_i(16)
    int.to_f/100
  end
end
