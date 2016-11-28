FactoryGirl.define do

  factory :blood_pressure_measurement, class: "Measurement::BloodPressure" do
    date        { Date.current }
    timestamp   { Time.now }
    value       { "120/90" }
  end

end
