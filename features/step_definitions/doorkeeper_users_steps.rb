When(/^a user authorizes my app$/) do
  @profile = FactoryGirl.create :profile
  @user ||= FactoryGirl.create :user
  @user.update_attributes profile: @profile
  Doorkeeper::AccessToken.create!(application: @developer_app, :resource_owner_id => @user.id)
  Doorkeeper::AccessGrant.create!(resource_owner_id: @user.id, application_id: @developer_app.id, redirect_uri: @developer_app.redirect_uri, expires_in: 600)
end

When(/^users authorize my app$/) do
  @profile = FactoryGirl.create :profile
  @user ||= FactoryGirl.create :user
  @user.update_attributes profile: @profile
  Doorkeeper::AccessToken.create!(application: @developer_app, :resource_owner_id => @user.id)
  Doorkeeper::AccessGrant.create!(resource_owner_id: @user.id, application_id: @developer_app.id, redirect_uri: @developer_app.redirect_uri, expires_in: 600)

  @profile2 = FactoryGirl.create :profile
  @user2 = FactoryGirl.create :user
  @user2.update_attributes profile: @profile2
  Doorkeeper::AccessToken.create!(application: @developer_app, :resource_owner_id => @user2.id)
  Doorkeeper::AccessGrant.create!(resource_owner_id: @user2.id, application_id: @developer_app.id, redirect_uri: @developer_app.redirect_uri, expires_in: 600)
end

Then(/^I can access their data$/) do
  access = Doorkeeper::AccessGrant.where(application_id: @developer_app.id).last
  expect(access.resource_owner_id).to eq(@user.id)
end

Then(/^I can see the user count$/) do
  resource_owners = Doorkeeper::AccessGrant.where(application_id: @developer_app.id).group_by(&:resource_owner_id)
  expect(resource_owners.count).to eq(1)
end

When(/^I authorize my app$/) do
  visit "/oauth/applications/#{@developer_app.id}"
  click_on "Authorize"
end

Then(/^it asks for authorization$/) do
  expect(page).to have_content("This application will be able to")
end


When(/^I go to my profile page$/) do
  visit "/user"
end

Then(/^it shows me my profile$/) do
  expect(page).to have_content(@developer.name)
end
