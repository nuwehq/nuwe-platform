FactoryGirl.define do

  factory :step_measurement, class: "Measurement::Step" do
    date        { Date.current }
    value       { "200" }
  end

end
