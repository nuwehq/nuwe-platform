FactoryGirl.define do

  factory :bpm_measurement, class: "Measurement::Bpm" do
    date        { Date.current }
    timestamp   { Time.now }
    value       { 120 }
  end

end
