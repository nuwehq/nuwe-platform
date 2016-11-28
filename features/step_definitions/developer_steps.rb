Given(/^I sign up as a Developer$/) do
  visit '/'
  within '.new_account' do
    @name = Faker::Name.name
    @email = Faker::Internet.email
    fill_in "user[name]", with: @name
    fill_in "user[email]", with: @email
    fill_in "user[password]", with: "letmeinplease"
    click_on "Developer free sign up"
  end
end

When(/^I sign up as a developer$/) do
  visit '/'
  within '.new_account' do
    @name = Faker::Name.name
    @email = Faker::Internet.email
    fill_in "user[name]", with: @name
    fill_in "user[email]", with: @email
    fill_in "user[password]", with: "letmeinplease"
    click_on "Developer free sign up"
  end
end

Given(/^I am signed in as a Developer$/) do
  @developer = FactoryGirl.create :user, name: "Developer Name", password: "letmeinplease", password_confirmation: "letmeinplease", source: "developer", roles: ["developer"]
  visit '/'
  within "#account" do
    fill_in "E-mail", with: @developer.email
    fill_in "Password", with: "letmeinplease"
    click_on "Log in"
  end
end
