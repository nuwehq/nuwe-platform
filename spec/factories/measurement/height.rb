FactoryGirl.define do

  factory :height_measurement, class: "Measurement::Height" do
    date                { Date.current }
    timestamp           { Time.current }
    value               { "1920" }
    unit                { "mm" }
    source              { "nuapi" }
  end

end
