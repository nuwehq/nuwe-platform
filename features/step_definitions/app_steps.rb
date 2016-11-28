Then(/^(.*) is added to my list of active apps$/) do |provider|
  provider.downcase!
  expect(@user.reload.apps.where(provider: provider)).to_not be_empty
end

When(/^I try to access an application page$/) do
  @developer = FactoryGirl.create :user, name: "Developer Name", password: "letmeinplease", password_confirmation: "letmeinplease", source: "developer", roles: ["developer"]
  @developer_app = FactoryGirl.create :oauth_application, owner_id: @developer.id, owner_type: "User", user_limit: true, request_limit: true
  visit "/oauth/applications/#{@developer_app.id}"
end

Then(/^I am redirected to the login screen$/) do
  expect(page).to have_content("Log in to Nuwe")
end

When(/^I try to access the applications' index page$/) do
  @developer = FactoryGirl.create :user, name: "Developer Name", password: "letmeinplease", password_confirmation: "letmeinplease", source: "developer", roles: ["developer"]
  @developer_app = FactoryGirl.create :oauth_application, owner_id: @developer.id, owner_type: "User", user_limit: true, request_limit: true
  visit "/oauth/applications/"
end
