require 'rails_helper'

RSpec.describe Service, :type => :model do

  let(:service) { FactoryGirl.create :service, name: "Factual UPC"}

  describe "type" do
    it "uses category name if present" do
      expect(service.type).to eq("ser cat name 1")
    end

    it "use service name when category not present" do
      service.update service_category: nil
      expect(service.type).to eq('factual-upc')
    end
  end

end
