FactoryGirl.define do

  factory :bmr_measurement, class: "Measurement::Bmr" do
    user
    date                { Date.current }
    timestamp           { Time.current }
    value               { "1802.5" }
    unit                { "kcal/day" }
    source              { "nutribu" }

  end

end
