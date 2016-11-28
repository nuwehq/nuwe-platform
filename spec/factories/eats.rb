FactoryGirl.define do

  factory :eat do

    factory :old_eat do
      created_at    { "2014-08-20T18:00:00.375Z" }
    end

    factory :yesterdays_eat do
      eaten_on    { Date.yesterday }
    end

  end

end