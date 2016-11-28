require 'rails_helper'

describe TeamNotification do
  it "has recipients" do
    sender = FactoryGirl.create :user
    other = FactoryGirl.create :user
    team = FactoryGirl.create :team
    FactoryGirl.create :membership, team: team, user: sender
    FactoryGirl.create :membership, team: team, user: other
    notification = FactoryGirl.create :team_notification, user: sender, team: team
    expect(notification.recipients).to include(other)
    expect(notification.recipients).to_not include(sender)
  end
end
