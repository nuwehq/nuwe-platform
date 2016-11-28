FactoryGirl.define do

  factory :team do
    name                { Faker::Company.name }

    factory :team_90 do
      activity_goal     90
      biometric_goal    90
      nutrition_goal    90
    end

    trait :device_users do
      after(:create) do |team, evaluator|
        membership = create :membership, team: team
        create :device, user: membership.user
      end
    end
  end

end
