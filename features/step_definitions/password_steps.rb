When(/^I click on the link in the email$/) do
  token = @user.tokens.where(scope: "api").first
  token_auth = { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Token.encode_credentials(token.id) }
  page.driver.post "/v1/reset_password", {user: {email: @user.email}}, token_auth
  email = ActionMailer::Base.deliveries.last
  body = Capybara.string(email.encoded)
  visit body.first('a')["href"]
end

Then(/^I can change my password$/) do
  within '#reset_password' do
    fill_in 'Password', with: "random_password"
    fill_in 'Password confirmation', with: "random_password"
    click_on 'Save'
  end
end

When(/^I click 'Forgot password\?'$/) do
  visit '/'
  click_on "Forgot password?"
end

When(/^I can enter my email address$/) do
  within '#forgot_password' do
    fill_in "E-mail", with: @user.email
    click_on "Submit"
  end
end

Then(/^I receive an email$/) do
  expect(ActionMailer::Base.deliveries.last.subject).to include("Nuwe password reset")
  expect(ActionMailer::Base.deliveries.last.to.first).to eq(@user.email)
end
