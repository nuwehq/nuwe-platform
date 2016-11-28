When(/^I visit the HumanAPI Connect page$/) do
  @token = @user.tokens.first.id
  visit "/apps?token=#{@token}"
end

When(/^I click the Connect button$/) do
  find("#connect-health-data-btn").click
end

When(/^I authorize a provider through HumanAPI$/) do
  # simulate a run through the popup and doing the callback
  Sidekiq::Testing.inline! do
    VCR.use_cassette "humanapi/callback", match_requests_on: [:method, :host, :path] do
      page.driver.post "/humanapi", {"humanId" => "c46b2614cd689d0746949085b90e0700", "clientId" => ENV["HUMANAPI_CLIENT_ID"], "sessionToken" => "8836c122c0483eb193ac2dd121136931"}
    end
  end
end

Then(/^I can choose a provider in the HumanAPI popup$/) do
  # this is ignored for now, until we test javasript as well
end

Then(/^I am connected with HumanAPI$/) do
  expect(@user.apps.where(provider: "humanapi").count).to eq(1)
end
