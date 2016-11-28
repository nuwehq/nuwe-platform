Then(/^I can log in$/) do
  visit "/session/new"
  fill_in "Email", with: @user.email
  fill_in "Password", with: @user.password
  click_on "Log in to NuWe"
end

Given(/^that I am not a User$/) do
  #no user stuff
end

Then(/^I can create a new account$/) do
  visit "/user/new"

  within "#regular" do
    fill_in "user[email]", with: Faker::Internet.email
    fill_in "user[password]", with: "letmeinplease"
    fill_in "Password confirmation", with: "letmeinplease"
    click_on "Save"
  end
end