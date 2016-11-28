require 'rails_helper'

describe V3::DeviceResultsController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:medical_device) { FactoryGirl.create :medical_device, application_id: oauth_application.id }
  let! (:different_medical_device) { FactoryGirl.create :different_medical_device, application_id: oauth_application.id }
  let! (:device_result) { FactoryGirl.create :device_result, medical_device_id: medical_device.id}
  let! (:column_value) { FactoryGirl.create :column_value, medical_device_id: medical_device.id}
  let! (:device_result_yesterday) { FactoryGirl.create :device_result_yesterday, medical_device_id: medical_device.id}
  let! (:device_result_correct_filename) { FactoryGirl.create :device_result_correct_filename, medical_device_id: medical_device.id}
  let! (:iot_user) { FactoryGirl.create :iot_user}


  before do
    oauth_user.profile.update FactoryGirl.attributes_for :profile_female
    Nu::Score.new(oauth_user).daily_scores(Date.current)
  end

  describe "index action" do
    it "returns correct results" do
      get "/v3/medical_devices/#{medical_device.token}/device_results.json"
      expect(json_body["device_results"]).to be_present
      expect(response.status).to eq(200)
    end
    it "is a paginated list" do
      3.times { FactoryGirl.create :device_result, medical_device_id: medical_device.id }
      get "/v3/medical_devices/#{medical_device.token}/device_results.json?per_page=1"
      expect(json_body["device_results"].length).to eq(1)
    end
    it "you can go through the pages" do
      get "/v3/medical_devices/#{medical_device.token}/device_results.json?page=2"
      expect(json_body["device_results"].length).to eq(0)
    end
  end

  describe "create device results" do
    it "returns status 201 and creates correct results" do
      post "/v3/medical_devices/#{medical_device.token}/device_results.json", {device_result: {columns: [{field_name:"temperature", type: "integer",read_only: true, editor: "text"}, {field_name: "humidity",type: "integer",read_only: true,editor: "text"}, {field_name: "created_at",type: "date",read_only: true, editor: "datePicker"}], data: [{temperature: 25, humidity: 26, created_at: "2015-09-21T09:07:51.628Z"}, {temperature: 24, humidity: 31, created_at: "2015-09-23T09:07:51.628Z" }]}}
      expect(json_body["device_results"]).to be_present
    end
    it "creates the device results for each table row" do
      expect {
        post "/v3/medical_devices/#{medical_device.token}/device_results.json", {device_result: {columns: [{field_name:"temperature", type: "integer",read_only: true, editor: "text"}, {field_name: "humidity",type: "integer",read_only: true,editor: "text"}, {field_name: "created_at",type: "date",read_only: true, editor: "datePicker"}], data: [{temperature: 24, humidity: 26, created_at: "2015-09-23T09:07:51.628Z"}, {temperature: 24, humidity: 26, created_at: "2015-09-23T09:07:51.628Z" }]}}
      }.to change(DeviceResult, :count).by(2)
    end
    it "creates the columns for the table" do
      expect {
        post "/v3/medical_devices/#{medical_device.token}/device_results.json", {device_result: {columns: [{field_name:"temperature", type: "integer",read_only: true, editor: "text"}, {field_name: "humidity",type: "integer",read_only: true,editor: "text"}, {field_name: "created_at",type: "date",read_only: true, editor: "datePicker"}], data: [{temperature: 24, humidity: 26, created_at: "2015-09-23T09:07:51.628Z"}, {temperature: 24, humidity: 26, created_at: "2015-09-23T09:07:51.628Z" }]}}
      }.to change(ColumnValue, :count).by(2)
    end
  end

  describe "update device results" do
    it "updates the correct results on patch" do
      patch "/v3/medical_devices/#{medical_device.token}/device_results/#{device_result.id}.json", {device_result: {columns: [{field_name:"heat", type: "integer",read_only: true, editor: "text"}, {field_name: "humidity",type: "integer",read_only: true,editor: "text"}, {field_name: "created_at",type: "date",read_only: true, editor: "datePicker"}], data: [{heat: 24, humidity: 26, created_at: "2015-09-23T09:07:51.628Z"}, {heat: 24, humidity: 26, created_at: "2015-09-23T09:07:51.628Z" }]}}
      expect(json_body["device_result"]["data"]).to be_present
    end
  end

  describe "destroy device results" do
    it "destroys the correct device results and column values" do
      3.times { FactoryGirl.create :device_result, medical_device_id: medical_device.id }
      3.times { FactoryGirl.create :column_value, medical_device_id: medical_device.id }
      expect {
        delete "/v3/medical_devices/#{medical_device.token}/device_results/#{device_result.id}.json"
      }.to change(DeviceResult, :count).by(-1)
      expect {
        delete "/v3/medical_devices/#{medical_device.token}/device_results/#{device_result.id}.json"
      }.to change(ColumnValue, :count).by(0)
    end
  end

  describe "column values are automatically populated" do
    it "and have correct values" do
      expect {
        post "/v3/medical_devices/#{medical_device.token}/device_results.json", {device_result: {data: [{temperature: 24, humidity: 26, uvlevel: 9}]}}
      }.to change(ColumnValue, :count).by(3)
      expect(medical_device.column_values.last.field_name).to eq("uvlevel")
    end
    it "adds a nil value if no info is given" do
      post "/v3/medical_devices/#{medical_device.token}/device_results.json", {device_result: {data: [{temperature: 24, humidity: 26}]}}
      expect(json_body["device_results"].first["data"]).to eq({"temperature"=>"24","humidity"=>"26","created_at"=>nil})
    end
    it "sets the correct types" do
      ColumnValue.destroy_all
      post "/v3/medical_devices/#{medical_device.token}/device_results.json", {device_result: {data: [{temperature: 24.0, humidity: 26.0}]}}
      expect(medical_device.column_values.last.type).to eq("float")
    end
  end

  describe "when I send a query" do
    before do
      4.times { FactoryGirl.create :device_result, medical_device_id: medical_device.id }
      3.times { FactoryGirl.create :device_result, medical_device_id: different_medical_device.id }
    end
    it "will return the result with the first results" do
      get "/v3/medical_devices/#{medical_device.token}/device_results/query.json", {query: {first: true}}
      expect(json_body["device_results"].length).to eq(1)
      expect(json_body["device_results"].first["id"]).to eq(medical_device.device_results.first.id)
    end
    it "will return the result with the last results" do
      get "/v3/medical_devices/#{medical_device.token}/device_results/query.json", {query: {last: true}}
      expect(json_body["device_results"].length).to eq(1)
      expect(json_body["device_results"].first["id"]).to eq(medical_device.device_results.last.id)
    end
    it "will return the result with the correct date" do
      get "/v3/medical_devices/#{medical_device.token}/device_results/query.json", {query: {date: Date.yesterday}}
      expect(json_body["device_results"].first["id"]).to eq(device_result_yesterday.id)
    end
    it "will return the results within a correct date range" do
      get "/v3/medical_devices/#{medical_device.token}/device_results/query.json", {query: {date_range: {from: Date.yesterday, to: Date.today}}}
      expect(json_body["device_results"].length).to eq(7)
    end
    it "will return the result with the correct filename" do
      get "/v3/medical_devices/#{medical_device.token}/device_results/query.json", {query: {filename: "correct_filename"}}
      expect(json_body["device_results"].first["filename"]).to eq("correct_filename")
    end
    it "will return the results of all medical_devices beloning to the same app" do
      get "/v3/medical_devices/#{medical_device.token}/device_results/query.json", {query: {medical_devices: [{device: medical_device.token},{device: different_medical_device.token}], dates: {from: Date.yesterday, to: Date.today}}}
      expect(json_body["device_results"].first["device_results"].first["id"]).to eq(DeviceResult.first.id)
    end
  end

  def base64_repfile
    base64 = Base64.encode64(File.read('spec/uploads/A115010001hba1c20151104145227.rep'))
    "data:text/plain;base64,#{base64}"
  end

  describe "when I upload a repfile" do
    before do
      FactoryGirl.create :access_grant, application: oauth_application, resource_owner_id: iot_user.id
    end
    it "will return the correct response" do
      post "/v3/medical_devices/#{medical_device.token}/device_results/upload.json", {device_result: {file: base64_repfile, filename: "A115010001hba1c20151104145227", upload_action: "rep-parser"}}
      expect(json_body["upload"]["filename"]).to eq("A115010001hba1c20151104145227")
    end
    it "will store the file" do
      expect {
        post "/v3/medical_devices/#{medical_device.token}/device_results/upload.json", {device_result: {file: base64_repfile, filename: "A115010001hba1c20151104145227", upload_action: "rep-parser"}}
      }.to change(DeviceFile, :count).by(1)
    end
    it "will create a new Device Result" do
      expect {
        post "/v3/medical_devices/#{medical_device.token}/device_results/upload.json", {device_result: {file: base64_repfile, filename: "A115010001hba1c20151104145227", upload_action: "rep-parser"}}
      }.to change(DeviceResult, :count).by(1)
    end
    it "will create a Device Result with correct data" do
      post "/v3/medical_devices/#{medical_device.token}/device_results/upload.json", {device_result: {file: base64_repfile, filename: "A115010001hba1c20151104145227", upload_action: "rep-parser"}}
      expect(DeviceResult.last.data).to eq({:measurement_magnetic_intensity=>2, :measurement_laser_power_dac=>656, :speed_profile_parameters=>"0215110201", :lock_in_frequency_f0=>10, :lock_in_frequency_f1=>14, :lock_in_frequency_f2=>20, :lock_in_frequency_f3=>30, :lock_in_frequency_f4=>40, :lock_in_frequency_f5=>60, :lock_in_frequency_f6=>70, :lock_in_frequency_f7=>100, :lock_in_frequency_f8=>130, :lock_in_frequency_f9=>180, :lock_in_frequency_f10=>250, :lock_in_frequency_f11=>350, :lock_in_frequency_f12=>480, :lock_in_frequency_f13=>660, :lock_in_frequency_f14=>910, :lock_in_frequency_f15=>1260, :lock_in_frequency_f16=>1740, :lock_in_frequency_f17=>2400, :lock_in_frequency_f18=>3310, :lock_in_frequency_f19=>4570, :lock_in_frequency_f20=>6310, :loop1_first_lock_in_time=>202, :loop1_temperature_sensor_value1=>25.95, :loop1_temperature_sensor_value2=>36.96, :loop1_data_real_0=>996, :loop1_data_real_1=>1007, :loop1_data_real_2=>983, :loop1_data_real_3=>949, :loop1_data_real_4=>897, :loop1_data_real_5=>826, :loop1_data_real_6=>745, :loop1_data_real_7=>645, :loop1_data_real_8=>541, :loop1_data_real_9=>437, :loop1_data_real_10=>331, :loop1_data_real_11=>244, :loop1_data_real_12=>155, :loop1_data_real_13=>91, :loop1_data_real_14=>33, :loop1_data_real_15=>-2, :loop1_data_real_16=>-23, :loop1_data_real_17=>-29, :loop1_data_real_18=>-26, :loop1_data_real_19=>-19, :loop1_data_real_20=>-13, :loop1_data_imag_0=>-58, :loop1_data_imag_1=>55, :loop1_data_imag_2=>113, :loop1_data_imag_3=>219, :loop1_data_imag_4=>312, :loop1_data_imag_5=>391, :loop1_data_imag_6=>463, :loop1_data_imag_7=>509, :loop1_data_imag_8=>545, :loop1_data_imag_9=>553, :loop1_data_imag_10=>540, :loop1_data_imag_11=>502, :loop1_data_imag_12=>461, :loop1_data_imag_13=>399, :loop1_data_imag_14=>333, :loop1_data_imag_15=>274, :loop1_data_imag_16=>208, :loop1_data_imag_17=>156, :loop1_data_imag_18=>118, :loop1_data_imag_19=>85, :loop1_data_imag_20=>67, :loop1_v0_0=>656, :loop1_v0_1=>656, :loop1_v0_2=>656, :loop1_v0_3=>656, :loop1_v0_4=>656, :loop1_v0_5=>656, :loop1_v0_6=>656, :loop1_v0_7=>656, :loop1_v0_8=>656, :loop1_v0_9=>656, :loop1_v0_10=>656, :loop1_v0_11=>656, :loop1_v0_12=>656, :loop1_v0_13=>656, :loop1_v0_14=>656, :loop1_v0_15=>656, :loop1_v0_16=>656, :loop1_v0_17=>656, :loop1_v0_18=>656, :loop1_v0_19=>656, :loop1_v0_20=>656, :loop2_first_lock_in_time=>302, :loop2_temperature_sensor_value1=>27.47, :loop2_temperature_sensor_value2=>36.16, :loop2_data_real_0=>1000, :loop2_data_real_1=>1010, :loop2_data_real_2=>978, :loop2_data_real_3=>953, :loop2_data_real_4=>896, :loop2_data_real_5=>832, :loop2_data_real_6=>736, :loop2_data_real_7=>646, :loop2_data_real_8=>542, :loop2_data_real_9=>437, :loop2_data_real_10=>333, :loop2_data_real_11=>240, :loop2_data_real_12=>152, :loop2_data_real_13=>79, :loop2_data_real_14=>32, :loop2_data_real_15=>-10, :loop2_data_real_16=>-30, :loop2_data_real_17=>-39, :loop2_data_real_18=>-34, :loop2_data_real_19=>-25, :loop2_data_real_20=>-18, :loop2_data_imag_0=>-63, :loop2_data_imag_1=>45, :loop2_data_imag_2=>110, :loop2_data_imag_3=>213, :loop2_data_imag_4=>307, :loop2_data_imag_5=>393, :loop2_data_imag_6=>485, :loop2_data_imag_7=>512, :loop2_data_imag_8=>544, :loop2_data_imag_9=>551, :loop2_data_imag_10=>536, :loop2_data_imag_11=>504, :loop2_data_imag_12=>459, :loop2_data_imag_13=>403, :loop2_data_imag_14=>336, :loop2_data_imag_15=>271, :loop2_data_imag_16=>208, :loop2_data_imag_17=>158, :loop2_data_imag_18=>107, :loop2_data_imag_19=>85, :loop2_data_imag_20=>65, :loop2_v0_0=>673, :loop2_v0_1=>673, :loop2_v0_2=>673, :loop2_v0_3=>673, :loop2_v0_4=>673, :loop2_v0_5=>673, :loop2_v0_6=>673, :loop2_v0_7=>673, :loop2_v0_8=>673, :loop2_v0_9=>673, :loop2_v0_10=>673, :loop2_v0_11=>673, :loop2_v0_12=>673, :loop2_v0_13=>673, :loop2_v0_14=>673, :loop2_v0_15=>673, :loop2_v0_16=>673, :loop2_v0_17=>673, :loop2_v0_18=>673, :loop2_v0_19=>673, :loop2_v0_20=>673, :error_code=>"00000000", :total_executing_time=>385, :concentration=>7.777681350708008, :disc_id=>"0200000004", :disc_manufacture_date=>"201501", :expiration_days=>"0100", :disc_factory_id=>"01", :disc_line_numbers=>"01", :disc_lot_numbers=>"0003", :curve_parameter_a=>16.139999389648438, :curve_parameter_b=>0.43299999833106995, :curve_parameter_c=>3602.0, :curve_parameter_d=>36.86000061035156, :curve_parameter_e=>0.0, :curve_parameter_f=>0.0, :machine_id=>"A115010001", :machine_factory_id=>"01", :machine_line_numbers=>"01", :model_id=>"D2.0", :h_w_id=>"0001", :mtk_firmware_version=>"X3010000", :micro_chip_firmware_version=>"1.0108", :app_software_version=>"12.34.56", :win_ap_version=>"1.0000", :operator_id=>"Marco", :bio_diagnostics_date=>"Wed, 04 Nov 2015 14:52:27 +0000", :bio_diagnostics_time=>"145227", :bio_diagnostics_item=>"02", :user_id=>iot_user.id, :user_email=>"iot_user@example.com"})
    end
    it "will create the correct ColumnValues" do
      ColumnValue.destroy_all
      expect {
        post "/v3/medical_devices/#{medical_device.token}/device_results/upload.json", {device_result: {file: base64_repfile, filename: "A115010001hba1c20151104145227", upload_action: "rep-parser"}}
      }.to change(ColumnValue, :count).by(185)
    end
    it "will find the correct user in the Nuwe db" do
      post "/v3/medical_devices/#{medical_device.token}/device_results/upload.json", {device_result: {file: base64_repfile, filename: "A115010001hba1c20151104145227", upload_action: "rep-parser"}}
      expect(DeviceResult.last.data).to include(:user_id => iot_user.id)
    end
  end
end
