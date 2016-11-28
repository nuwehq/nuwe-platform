require 'rails_helper'

describe Subscription, :type => :model do

  describe "formatted_price" do

    it "formats price with 2 decimal places if price has cents" do
      subscription = FactoryGirl.create :subscription, price: 60099
      expect(subscription.formatted_price).to eq("$600.99")
    end

    it "formats price without decimal if price has no cents" do
      subscription = FactoryGirl.create :subscription, price: 60000
      expect(subscription.formatted_price).to eq("$600")
    end
  end
end
