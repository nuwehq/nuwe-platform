When(/^I choose a subscription$/) do
  visit "/oauth/applications"
  @application = Doorkeeper::Application.first
  visit "/oauth/applications/#{@application.id}"
  @subscription = Subscription.second
  visit "/subscription/#{@subscription.id}/purchase/new?application_id=#{@application.id}"
end

Then(/^I see that my subscription is selected$/) do
  expect(@developer_app.subscriptions.last).to eq(@subscription)
end

Given(/^these subscription plans:$/) do |table|
  table.hashes.each do |row|
    @subscription = Subscription.create name: row['Name'], price: (row['Price'].to_i * 100)
  end
end

When(/^I have the DEV plan$/) do
  @user = FactoryGirl.create :developer
  @application = Doorkeeper::Application.create! redirect_uri: "urn:ietf:wg:oauth:2.0:oob", name: "Test App", owner_id: @user.id, owner_type: "User"
end
