FactoryGirl.define do

  factory :bmi_measurement, class: "Measurement::Bmi" do
    user
    date                { Date.current }
    timestamp           { Time.current }
    value               { "25.0" }
    unit                { "kg/m3" }
    source              { "nuapi" }

    factory :bmi_measurement_yesterday do
      date              { Date.yesterday }
      timestamp         { 1.day.ago }
    end
  end

end
