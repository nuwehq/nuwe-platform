Given(/^I have a Developer App$/) do
  @developer_app = FactoryGirl.create :oauth_application, owner_id: @developer.id, owner_type: "User", user_limit: true, request_limit: true
 end

 Given(/^That App hase Parse server enabled$/) do
  @parse_app = FactoryGirl.create :parse_app, application: @developer_app
  @parse_app.port = 80
  @parse_app.save!
end

When(/^I visit Developer Apps page$/) do
  visit "/oauth/applications"
end

When(/^I click Create button$/) do
  visit "/oauth/applications/new"
end

When(/^I enter a name for my App$/) do
  fill_in "doorkeeper_application[name]", with: "New App"
  first('.fields').click_button('Next')
end

When(/^I click Edit button$/) do
  visit "/oauth/applications/#{@developer_app.id}"
end

When(/^I change the name of my App$/) do
  fill_in "doorkeeper_application[name]", with: "Updated App"
end

When(/^I click on an Details button$/) do
  visit "/oauth/applications/#{@developer_app.id}"
end

When(/^I click the Delete button$/) do
  expect(@developer.oauth_applications.count).to eq(1)
  click_link("delete-app")
end

Then(/^I see a new app added to my list of apps$/) do
  expect(page).to have_content("New App")
end

Then(/^the App received an Application ID and a Secret$/) do
  visit "/oauth/applications/#{@developer_app.id}"
  #click_on 'Keys'
  expect(page).to have_content("Application ID")
  expect(page).to have_content("Client Secret")
end

Then(/^I see the App details page$/) do
  expect(page).to have_content(@developer_app.name)
end

Then(/^the app is Deleted from my list of apps$/) do
  expect(page).to have_content("Application deleted.")
end


Given(/^I am on the Scale plan$/) do
  Purchase.create! subscription_id: @subscription.id, application_id: @developer_app.id, expires_on: (Date.current + 1.year)
end

When(/^I go to my app's details page$/) do
  visit "/oauth/applications/#{@developer_app.id}"
end

When(/^there have been more users than allowed in my subscription$/) do
  expect(@developer_app.user_limit).to eq(true)
end

Then(/^I expect to see a warning message$/) do
  expect(page).to have_content("You are over your limit")
end

When(/^there have been more requests than allowed in my subscription$/) do
  expect(@developer_app.request_limit).to eq(true)
end

When(/^I visit another Developer Apps page$/) do
  @developer2 = FactoryGirl.create :user
  @developer_app2 = FactoryGirl.create :oauth_application, owner_id: @developer2.id, owner_type: "User"
  visit "/oauth/applications/#{@developer_app2.id}"
end

When(/^the app does not belong to me$/) do
  expect(@developer.id).not_to eq(@developer2.id)
end

Then(/^I expect to not see the Developer Apps page$/) do
  expect(page).to have_content("Goodness, we don't even")
end

Given(/^there is a service called Parse Core$/) do
  parse = FactoryGirl.create :service, name: "Parse Core", lib_name: "parse_core"
end
