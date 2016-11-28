FactoryGirl.define do

  factory :blood_oxygen_measurement, class: "Measurement::BloodOxygen" do
    date  { Date.current }
    value { 96.5 }
    timestamp  { Time.current }
  end
end
