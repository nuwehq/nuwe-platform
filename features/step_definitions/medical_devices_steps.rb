When(/^I enter a name for my device$/) do
  @device = FactoryGirl.create :medical_device, application: @developer_app
  fill_in 'medical_device_name', with: @device.name
end

When(/^I click on Add Device$/) do
  click_on "Add Device"
end

Then(/^I see a new device added to my list of devices$/) do
  expect(page).to have_content(@device.name)
end

When(/^I have already added a device$/) do
  @device = FactoryGirl.create :medical_device, application: @developer_app
  expect(@developer_app.medical_devices.count).to eq(1)
end

When(/^I click the Delete Device button$/) do
  click_link "delete-device"
end

Then(/^the device is deleted from my list of devices$/) do
  expect(page).to have_content("The device has been deleted.")
  expect(@developer_app.medical_devices.count).to eq(0)
end

When(/^the device has received uploads$/) do
  @medical_device = @developer_app.medical_devices.first
  @medical_device.device_files.create
end

When(/^I click Edit Device button$/) do
  click_link "edit-device"
end

When(/^I change the name of my device$/) do
  fill_in 'medical_device_name', with: "new name"
end

When(/^I click on Update Device$/) do
  click_on "Update Device"
end

Then(/^the device name is changed$/) do
  expect(page).to have_content("new name")
end
