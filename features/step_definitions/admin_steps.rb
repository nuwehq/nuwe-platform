Given(/^I am signed in as an Admin$/) do
  @developer = FactoryGirl.create :user
  @developer.update_attributes name: "Admin Name", password: "letmeinplease", password_confirmation: "letmeinplease", roles: ["developer", "admin"]
  visit '/'
  within "#account" do
    fill_in "E-mail", with: @developer.email
    fill_in "Password", with: "letmeinplease"
    click_on "Log in"
  end
end

When(/^I click on 'Edit' for Factual UPC$/) do
  @factual_upc_service = Service.find_by lib_name: "factual_upc"
  visit "/services/#{@factual_upc_service.id}/edit"
end

When(/^I change the description of the service$/) do
  fill_in "service[description]", with: "new description"
end

When(/^I click 'Save'$/) do
  click_on "Save"
end

When(/^I click on 'Add a New Service'$/) do
  click_on "Add a New Service"
end

When(/^I enter the name of the service$/) do
  fill_in "service[name]", with: "new service"
end
