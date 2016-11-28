When(/^I authorize myself with (.*)$/) do |provider|
  provider.downcase!
  token = @user.tokens.first.id

  VCR.use_cassette "auth/#{provider}", record: :new_episodes, match_requests_on: [:host] do
    visit "/auth/#{provider}?state=#{token}"
  end
end
