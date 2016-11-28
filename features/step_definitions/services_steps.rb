Given(/^these services:$/) do |table|
  table.hashes.each do |row|
    category = FactoryGirl.create :service_category, name: row['Category']
    needs_remote_credentials = (row['Needs remote credentials'] == 'true')
    FactoryGirl.create :service, service_category: category, name: row['Name'], lib_name: row['LibName'], description: row['Description'], needs_remote_credentials: needs_remote_credentials
  end
end

When(/^I enable Pusher$/) do
  @pusher_service = Service.find_by lib_name: "pusher"
  visit "/oauth/applications/#{@developer_app.id}"
  expect(page).to have_content("Realtime push notifications for your app")
  @developer_app.capabilities.create! service: @pusher_service
end

Then(/^Pusher is activated for my app$/) do
  @developer_app.capabilities.where(service: @pusher_service).first == @pusher_service
end

When(/^I enable Factual UPC$/) do
  @factual_upc_service = Service.find_by lib_name: "factual_upc"
  visit "/oauth/applications/#{@developer_app.id}"
  expect(page).to have_content("Over 600,000 consumer packaged goods in a UPC centric database")
  @developer_app.capabilities.create! service: @factual_upc_service
  expect(@developer_app.capabilities.last.service).to eq(@factual_upc_service)
end

When(/^I enable Nuwe Parse$/) do
  @parse_server_service = Service.where(lib_name: "parse_core").last
  @developer_parse_app = FactoryGirl.create :oauth_application, owner_id: @developer.id, owner_type: "User", user_limit: true, request_limit: true, uid: "blah", id: 881
  VCR.use_cassette "parse/cloud66", match_requests_on: [:method, :host, :path] do
    patch "/services/#{@parse_server_service.id}/toggle", :application_id => "#{@developer_parse_app.id}"
  end
  expect(@developer_parse_app.capabilities.last.service).to eq(@parse_server_service)
  visit "/oauth/applications/#{@developer_parse_app.id}#parse"
  expect(page).to have_content("Your server is currently being provisioned.")
end

When(/^I enter my factual credentials$/) do
  visit "/oauth/applications/#{@developer_app.id}"
  click_on "Enter your credentials for Factual UPC"
  fill_in "capability[remote_application_key]", with: "1234567890"
  fill_in "capability[remote_application_secret]", with: "0987654321"
  click_on "Save"
end

Then(/^Factual UPC is activated for my app$/) do
  @developer_app.capabilities.where(service: @factual_upc_service).first == @factual_upc_service
  expect(@developer_app.capabilities.first.remote_application_key).to eq("1234567890")
  expect(@developer_app.capabilities.first.remote_application_secret).to eq("0987654321")
end

Then(/^Parse is activated for my app$/) do
  @developer_app.capabilities.where(service: @parse_server_service).first == @parse_server_service
end
