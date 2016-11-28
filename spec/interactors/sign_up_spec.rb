require 'rails_helper'

describe SignUp do

  it_behaves_like "failure on missing email"
  it_behaves_like "failure on missing password"

  let(:attributes) { FactoryGirl.attributes_for :user }
  let(:user) { User.find_by_email! attributes[:email] }

  def sign_me_up
    VCR.use_cassette "users/create" do
      SignUp.call(attributes)
    end
  end

  it "creates a user" do
    expect do
      sign_me_up
    end.to change(User, :count).by(1)
  end

  it "creates an api token" do
    expect do
      sign_me_up
    end.to change(Token, :count).by(1)
  end

  it "creates a preference for metric units" do
    sign_me_up
    expect(user.preferences.where(name: "units", value: "metric")).to_not be_empty
  end

  it "send confim email" do
    Sidekiq::Testing.inline! do
      sign_me_up
    end
    expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
  end

end
