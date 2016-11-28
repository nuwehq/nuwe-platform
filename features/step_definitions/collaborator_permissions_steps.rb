Given(/^I am logged in collaborator$/) do
  @some_developer = FactoryGirl.create :user
  @developer_app = FactoryGirl.create :oauth_application, owner_id: @some_developer.id, owner_type: "User", name: "Collab app", user_limit: true, request_limit: true
  @collaborator = FactoryGirl.create :user

  visit '/'
  within "#account" do
    fill_in "E-mail", with: @collaborator.email
    fill_in "Password", with: @collaborator.password
    click_on "Log in"
  end
end

Given(/^I have been added to an app$/) do
  @developer_app.collaborations.create!(application: @developer_app, user: @collaborator)
end

When(/^I visit my applications page$/) do
  visit '/oauth/applications'
end

Then(/^I see the app$/) do
  expect(page).to have_content("Collab app")
end

When(/^I visit the app's show page$/) do
  visit "/oauth/applications/#{@developer_app.id}"
  expect(page).to have_content("Collab app")
end

Then(/^I cannot delete the application$/) do
  visit "/oauth/applications/#{@developer_app.id}"
  expect(page).to have_content("You are not the creator fo this app and can not delete it.")
end
