require 'rails_helper'

describe ProcessNotificationMessage do

  let!(:developer) {FactoryGirl.create :developer, name: "Developer Name", password: "letmeinplease", password_confirmation: "letmeinplease", source: "developer", roles: ["developer"]}
  let!(:developer_app) {FactoryGirl.create :oauth_application, owner_id: developer.id, owner_type: "User"}
  let!(:profile) {FactoryGirl.create :profile}
  let!(:user) {FactoryGirl.create :user, profile: profile}

  it "creates a notification" do
    alert = FactoryGirl.create :alert, engine: "{{email}}", text: "Hi there!", application: developer_app
    ProcessNotificationMessage.new(alert, user).transform
    expect(Notification.count).to eq(1)
    expect(Notification.last.recipient).to eq(user)
    expect(Notification.last.message).to eq(alert.text)
  end

  it "replaces {{first_name}} with a user's first name" do
    user.profile.update_attributes first_name: "Gorby"
    alert = FactoryGirl.create :alert, engine: "{{email}}", text: "Hi {{first_name}}!", application: developer_app
    ProcessNotificationMessage.new(alert, user).transform
    expect(Notification.last.message).to eq("Hi #{user.first_name}!")
  end

  it "replaces {{first_name}} with generic name if a user's first name isn't available " do
    alert = FactoryGirl.create :alert, engine: "{{email}}", text: "Hi {{first_name}}!", application: developer_app
    ProcessNotificationMessage.new(alert, user).transform
    expect(Notification.last.message).to eq("Hi user!")
  end

end
