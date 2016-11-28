FactoryGirl.define do

  factory :activity_measurement, class: "Measurement::Activity" do
    user

    date                { Date.current }
    start_time          { 2.hours.ago }
    end_time            { 1.hour.ago }
    type                { "cycling" }
    duration            { 1000 }

    factory :activity_measurement_steps do
      type              {"steps"}
    end

    factory :activity_measurement_yesterday do
      date              { Date.yesterday }
      start_time        { 1.day.ago - 2.hours }
      end_time          { 1.day.ago - 1.hour }
    end
  end

end
