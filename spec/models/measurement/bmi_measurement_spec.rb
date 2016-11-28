require 'rails_helper'

describe Measurement::Bmi do

  it "calculates prime" do
    measurement = FactoryGirl.create :bmi_measurement
    expect(measurement.prime).to eq(measurement.value/25)
  end

end
