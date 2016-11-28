FactoryGirl.define do

  factory :meal do
    user

    name        { Faker::Lorem.word }
    type        { %w(breakfast lunch dinner snack).sample }
    lat         { "50.8571601" }
    lon         { "-2.1645891" }

    factory :supper do
      after(:create) do |meal|
        ingredient = FactoryGirl.create :pasta_corn_cooked
        meal.components.create ingredient: ingredient, amount: 2
      end
    end
  end

end
