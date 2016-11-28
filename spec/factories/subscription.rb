FactoryGirl.define do

  factory :subscription do
    description           { "Perfect for when you start to really get traction" }

    factory :test_subscription do
      name                { "test" }
      user_limit          { 4 }
      api_call_limit      { 4 }
    end

    factory :dev_subscription do
      name                { "DEV" }
      user_limit          { 1000 }
      api_call_limit      { 1000 }
    end

    factory :scale_subscription do
      name                { "Scale" }
      user_limit          { 100000 }
      api_call_limit      { 10_000_000 }
    end

    factory :unicorn_subscription do
      name                { "Unicorn" }
    end 
  end
end
