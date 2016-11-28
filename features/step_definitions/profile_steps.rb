When(/^I visit Profile page$/) do
  visit "/user"
end

When(/^I change my title$/) do
  fill_in "Title", with: "Ruby Developer"
end

When(/^I click Update$/) do
  click_on "Update"
end