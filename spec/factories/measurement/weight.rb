FactoryGirl.define do

  factory :weight_measurement, class: "Measurement::Weight" do
    date                { Date.current }
    timestamp           { Time.current }
    value               { "88000" }
    unit                { "grams" }
    source              { "nuapi" }
  end

end
