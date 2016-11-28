FactoryGirl.define do

  factory :body_fat_measurement, class: "Measurement::BodyFat" do
    date        { Date.current }
    timestamp   { Time.now }
    value       { 18.9 }
  end

end
