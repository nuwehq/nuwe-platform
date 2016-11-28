Before('@push_notifications') do
  @grocer_server = Grocer.server(port: 2195)
  @grocer_server.accept # starts listening in background
end

After('@push_notifications') do
  @grocer_server.close
end

When(/^I click on the Create a Notification button$/) do
  click_on "Create a Notification"
end

When(/^I create an alert$/) do
  fill_in 'alert_engine', with: "Send {{all_users}} a {{email}}"
  fill_in 'alert_text', with: "Hi {{first_name}}"
end

When(/^I click on the Send Notification button$/) do
  click_on "Send Notification"
end

Then(/^a notification is created$/) do
  expect(Alert.count).to eq(1)
  expect(Notification.count).to eq(2)
end

When(/^a user has push notifications active$/) do
  @device = FactoryGirl.create :device, user: @user
  @device2 = FactoryGirl.create :device, token: "<fe15a27d5df3c34778defb1f4f3880265cc52c0c047682223be59fb68500a9a2>", user: @user2
end

When(/^I create a push notification for all users$/) do
  @alert = @developer_app.alerts.create! engine: "Send a {{push_notification}} to {{all_users}}", text: "Hi {{first_name}}! Time for a run!"
  AlertJob.perform_later(@alert, )
end

When(/^I create a push notification for a user$/) do
  @alert = @developer_app.alerts.create! engine: "Send a {{push_notification}} to {{user:#{@user.email}}}", text: "Hi {{first_name}}! Time for a workout!"
  AlertJob.perform_later(@alert)
end


Then(/^all users receive a push notification$/) do
  Timeout.timeout(3) {
    notification1 = @grocer_server.notifications.pop
    notification2 = @grocer_server.notifications.pop
    expect(notification1.alert).to eq("Hi #{@user2.first_name}! Time for a run!")
    expect(notification2.alert).to eq("Hi #{@user.first_name}! Time for a run!")
  }
end

Then(/^a user receives a push notification$/) do
  Timeout.timeout(3) {
    notification = @grocer_server.notifications.pop # blocking
    expect(notification.alert).to eq("Hi #{@user.first_name}! Time for a workout!")
  }
end

When(/^I create an email notification for all users$/) do
  @alert = @developer_app.alerts.create! engine: "Send {{all_users}} a {{email}}", text: "Hi {{first_name}}! Time for a workout!"
end

When(/^I create an email notification for a user$/) do
  @alert = @developer_app.alerts.create! engine: "{{email}} to {{user:#{@user.email}}}", text: "Hi {{first_name}}! Time for a workout!"
end

Then(/^all users receive a email notification$/) do
  expect{
    AlertJob.perform_later(@alert)
  }.to change(ActionMailer::Base.deliveries, :count).by(2)
end

Then(/^a user receives a email notification$/) do
  expect{
    AlertJob.perform_later(@alert)
  }.to change(ActionMailer::Base.deliveries, :count).by(1)
  expect(ActionMailer::Base.deliveries.map{|email|email.to.first}).to include(@user.email)
end

When(/^I create an email notification for a nonexistent user$/) do
  @alert = @developer_app.alerts.create! engine: "{{email}} to {{user:nonexistent_user@example.com}}", text: "Hi {{first_name}}! Time for a workout!"
end

Then(/^no email notification is created$/) do
  expect{
    AlertJob.perform_later(@alert)
  }.to change(Notification, :count).by(0)
end

When(/^a user has authorized my application multiple times$/) do
  Doorkeeper::AccessGrant.create!(resource_owner_id: @user.id, application_id: @developer_app.id, redirect_uri: @developer_app.redirect_uri, expires_in: 600)
  Doorkeeper::AccessGrant.create!(resource_owner_id: @user.id, application_id: @developer_app.id, redirect_uri: @developer_app.redirect_uri, expires_in: 600)
  Doorkeeper::AccessGrant.create!(resource_owner_id: @user.id, application_id: @developer_app.id, redirect_uri: @developer_app.redirect_uri, expires_in: 600)
end

Then(/^a user does not receive more than one email notification$/) do
  expect{
    AlertJob.perform_later(@alert)
  }.to change(ActionMailer::Base.deliveries, :count).by(1)
  expect(ActionMailer::Base.deliveries.map{|email|email.to.first}).to include(@user.email)
end

Then(/^users do not receive more than one email notification$/) do
  expect{
    AlertJob.perform_later(@alert)
  }.to change(ActionMailer::Base.deliveries, :count).by(2)
end

When(/^I am on the notification page$/) do
  step "I go to my app's details page"
  step "I click on the Create a Notification button"
end

When(/^I edit the notifaction on the alert page$/) do
  visit "/applications/#{@developer_app.id}/alerts/#{@alert.id}/edit"
  fill_in "alert_engine", with: "Send an {{email}} to {{#{@user.email}}}"
  fill_in "alert_text", with: "Go for a run immediately. Because: zombies."
  click_on "Send Notification"
end

Then(/^the notifation is edited$/) do
  visit "/oauth/applications/#{@developer_app.id}#notifications"
  expect(page).to have_content("Go for a run immediately. Because: zombies.")
end

Then(/^I can see a list of my notifications$/) do
  visit "/oauth/applications/#{@developer_app.id}#notifications"
  expect(page).to have_content("Notifications Sent")
end

Then(/^I can upload my pem certificate$/) do
  @developer_parse_app = FactoryGirl.create :oauth_application, owner_id: @developer.id, owner_type: "User", user_limit: true, request_limit: true, uid: "blah", id: 881
  @parse_app = FactoryGirl.create :parse_app, application: @developer_parse_app
  VCR.use_cassette 'parse/certificate' do
    visit "/applications/#{@developer_parse_app.id}/alerts/certificate"
    attach_file("APNs Certificate", "spec/uploads/apns.pem")
    fill_in "Bundle ID", with: "com.myCompany.myApp"
    click_button 'Submit'
    expect(page).to have_content("Thank you for updating your notification details.")
  end
end
