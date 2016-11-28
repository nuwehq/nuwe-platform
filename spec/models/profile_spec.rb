require 'rails_helper'

describe Profile do

  let(:profile) { FactoryGirl.create :profile }

  it "does not allow facebook_id twice" do
    profile_1 = Profile.create FactoryGirl.attributes_for :facebook_profile
    profile_2 = Profile.create FactoryGirl.attributes_for :facebook_profile
    expect(profile_2).to_not be_valid
  end

  %i(tiny small medium).each do |size|
    it "generates a #{size} thumbnail" do
      profile.update_attribute :avatar, File.open('spec/uploads/avatar.jpg')
      expect(profile.avatar.exists?(size)).to eq(true)
    end
  end

end
