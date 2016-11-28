When(/^there have been twenty requests this month$/) do
  20.times { FactoryGirl.create :stat, application_id: @developer_app.id }
end

When(/^ten requests last month$/) do
  10.times { FactoryGirl.create :old_stat, application_id: @developer_app.id }
end

Then(/^I expect to see twenty requests$/) do
  visit "/oauth/applications"
  expect(page).to have_content("20")
end