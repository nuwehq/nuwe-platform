When(/^a user has added height measurements$/) do
  @user.height_measurements.create value: 1.82, unit: "m", source: "self-measurement", date: Date.yesterday, timestamp: Time.current
end

When(/^I click on "(.*?)"$/) do |name|
  click_on name
end

Then(/^I see the user's height data$/) do
  expect(page).to have_content("1.82")
end

When(/^a user has added step measurements$/) do
  @user.step_measurements.create value: 150, date: Date.yesterday, timestamp: Time.current
end

Then(/^I see the user's step data$/) do
  expect(page).to have_content("150")
end

When(/^a user has added BPM measurements$/) do
  @user.bpm_measurements.create value: 60, date: Date.yesterday, timestamp: Time.current
end

Then(/^I see the user's BPM data$/) do
expect(page).to have_content("60")
end

When(/^a user has added weight measurements$/) do
  @user.weight_measurements.create value: 68, unit: "kg", source: "self-measurement", date: Date.yesterday, timestamp: Time.current
end

Then(/^I see the user's weight data$/) do
  expect(page).to have_content("68")
end

When(/^a user has added blood pressure measurements$/) do
  @user.blood_pressure_measurements.create value: "120/80", date: Date.yesterday, timestamp: Time.current
end

Then(/^I see the user's blood pressure data$/) do
  expect(page).to have_content("120/80")
end

When(/^a user has added blood oxygen measurements$/) do
  @user.blood_oxygen_measurements.create value: "99", date: Date.yesterday, timestamp: Time.current
end

Then(/^I see the user's blood oxygen data$/) do
  expect(page).to have_content("99")
end

When(/^a user has added body fat measurements$/) do
  @user.body_fat_measurements.create value: 24.5, date: Date.yesterday, timestamp: Time.current
end

Then(/^I see the user's body fat data$/) do
  expect(page).to have_content("24.5")
end

When(/^a user has BMR measurements$/) do
  @user.bmr_measurements.create value: 1442, unit: "kcal/day", source: "nutribu", date: Date.yesterday, timestamp: Time.current
end

Then(/^I see the user's BMR data$/) do
  expect(page).to have_content("1442")
end

When(/^a user has BMI measurements$/) do
  @user.bmi_measurements.create value: 22, unit: "kg/m2", source: "nutribu", date: Date.yesterday, timestamp: Time.current
end

Then(/^I see the user's BMI data$/) do
  expect(page).to have_content("22")
end
