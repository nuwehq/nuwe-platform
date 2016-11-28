Given(/^that I have never logged in before$/) do
  # No user exists in the DB yet
end

Given(/^that I have logged in before$/) do
  FactoryGirl.create :old_user_github
end

Then(/^I can log into the platform$/) do
  visit '/'
  first('.oauth').click_link('GitHub')
  VCR.use_cassette "auth/github", record: :new_episodes, match_requests_on: [:method, :host, :path] do
    visit "/auth/github"
  end
  expect(page).to have_content("You logged in successfully")
end

Given(/^I am not a developer$/) do
  @user = FactoryGirl.create :old_user_github
  @user.name = Faker::Name.first_name
end

Given(/^I log into the platform$/) do
  visit '/'
  first('.oauth').click_link('GitHub')
  VCR.use_cassette "auth/github", record: :new_episodes, match_requests_on: [:method, :host, :path] do
    visit "/auth/github"
  end
  expect(page).to have_content("You logged in successfully")
end

Given(/^I am a developer$/) do
  @developer = FactoryGirl.create :old_user_github
  @developer.roles << 'developer'
  @developer.save!
end