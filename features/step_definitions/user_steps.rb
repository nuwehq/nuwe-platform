Given(/^I have signed up using the Nuwe app$/) do
  @user = FactoryGirl.create :user
end

Then(/^I'm added to the "(.*?)" role$/) do |role|
  @user = User.find_by_email!(@email)
  expect(@user.roles).to include(role)
end

Given(/^that I am a User$/) do
  @user = FactoryGirl.create :user
end

When(/^I log in on the Developer platform$/) do
  visit '/'
  within "#account" do
    fill_in "E-mail", with: @user.email
    fill_in "Password", with: @user.password
    click_on "Log in"
  end
end

When(/^I fill in my name and click agree$/) do
  within '#developer_accept' do
    fill_in "user_name", with: @user.name
    click_button "Developer free sign up"
  end
end


When(/^I sign up with new account details$/) do
  visit '/'
  within '#new_user' do
    fill_in "user_name", with: "John Wayne"
    fill_in "user_email", with: "johnwayne@example.com"
    fill_in "user_password", with: "letmeinplease"
    click_button "Developer free sign up"
  end
end


Then(/^I have a Nuwe account$/) do
  expect(page).to have_content("Create a new App")
end
