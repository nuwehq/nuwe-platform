When(/^I enter another developer's email address$/) do
  visit "/oauth/applications/#{@developer_app.id}"
  expect(page).to have_content("Add a new collaborator")
  @developer2 = FactoryGirl.create :user
  fill_in "email address", with: @developer2.email
end

When(/^I click Add Collaborator$/) do
  click_on "Add Collaborator"
end

Then(/^I see a collaborator is added$/) do
  expect(page).to have_content("#{@developer2.email}")
end

Given(/^I have a collaborator I want to remove$/) do
  @developer_app = FactoryGirl.create :oauth_application, owner_id: @developer.id, owner_type: "User", user_limit: true, request_limit: true
  @developer2 = FactoryGirl.create :user 
  @developer_app.collaborations.create!(application: @application, user: @developer2)
end

When(/^I click Remove$/) do
  click_on "Remove"
end

Then(/^the collaborator is deleted from my list of collaborators$/) do
  expect(page).to_not have_content("#{@developer2.email}")
end

When(/^I enter a nonexistent email address$/) do
  visit "/oauth/applications/#{@developer_app.id}"
  expect(page).to have_content("Add a new collaborator")
  fill_in "email address", with: " "
end

When(/^I add a collaborator$/) do
  @developer_app = FactoryGirl.create :oauth_application, owner_id: @developer.id, owner_type: "User", user_limit: true, request_limit: true
  @developer2 = FactoryGirl.create :user 
  @developer_app.collaborations.create!(application: @application, user: @developer2)
end

Then(/^the collaborator receives an email notification$/) do
  expect(ActionMailer::Base.deliveries.map{|email|email.to.first}).to include(@developer2.email)
end