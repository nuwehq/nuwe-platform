FactoryGirl.define do

  factory :invitation do
    team
    user

    email       { Faker::Internet.email }
  end

end
