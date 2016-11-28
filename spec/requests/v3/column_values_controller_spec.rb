require 'rails_helper'

describe V3::ColumnValuesController do

  include_context "signed up developer"
  include_context "authenticated user"
  include_context "bearer token authentication"

  let! (:medical_device) { FactoryGirl.create :medical_device, application_id: oauth_application.id }
  let! (:device_result) { FactoryGirl.create :device_result, medical_device_id: medical_device.id}
  let! (:column_value) { FactoryGirl.create :column_value, medical_device_id: medical_device.id}
  let! (:different_medical_device) { FactoryGirl.create :different_medical_device, application_id: oauth_application.id}

  before do
    oauth_user.profile.update FactoryGirl.attributes_for :profile_female
    Nu::Score.new(oauth_user).daily_scores(Date.current)
  end

  describe "create columns" do
    it "returns status 201 and creates correct results" do
      post "/v3/medical_devices/#{medical_device.token}/column_values.json", {columns: [{field_name:"temperature", type: "integer",read_only: true, editor: "text"}, {field_name: "humidity",type: "integer",read_only: true,editor: "text"}, {field_name: "created_at",type: "date",read_only: true, editor: "datePicker"}] }
      expect(json_body["column_values"]).to be_present
    end
    it "has deleted the old and created 3 new columns" do
      expect{
        post "/v3/medical_devices/#{medical_device.token}/column_values.json", {columns: [{field_name:"temperature", type: "integer",read_only: true, editor: "text"}, {field_name: "humidity",type: "integer",read_only: true,editor: "text"}, {field_name: "created_at",type: "date",read_only: true, editor: "datePicker"}] }
      }.to change(ColumnValue, :count).by(2)
    end
  end

  describe "index columns" do
    it "returns all the columns for a certain medical device" do
      get "/v3/medical_devices/#{medical_device.token}/column_values.json"
      expect(json_body["column_values"]).to be_present
    end
  end

  describe "update columns" do
    it "returns the correct column values" do
      patch "/v3/medical_devices/#{medical_device.token}/column_values/#{column_value.id}.json", {column_value: {field_name:"heat", type: "integer",read_only: true, editor: "text"}}
      expect(json_body["column_value"]).to be_present
    end

    it "sets the visible column to false" do
      patch "/v3/medical_devices/#{medical_device.token}/column_values/#{column_value.id}.json", {column_value: {field_name:"bananas", type: "integer",read_only: true, editor: "text", visible: false}}
      expect(json_body["column_value"]["visible"]).to be(false)
    end

    it "only updates for correct medical_device" do
      patch "/v3/medical_devices/#{different_medical_device.token}/column_values/#{column_value.id}.json", {column_value: {field_name:"heat", type: "integer",read_only: true, editor: "text"}}
      expect(json_body["error"]["message"]).to eq("Columns don't match medical device.")
    end
  end

  describe "destroy column values" do
    it "destroys the correct column values" do
      3.times { FactoryGirl.create :column_value, medical_device_id: medical_device.id }
      expect {
        delete "/v3/medical_devices/#{medical_device.token}/column_values/#{column_value.id}.json"
      }.to change(ColumnValue, :count).by(-1)
    end
  end

end
