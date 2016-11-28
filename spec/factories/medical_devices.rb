FactoryGirl.define do

  factory :medical_device do
    name        { Faker::Lorem.word }

    factory :different_medical_device do
      name        { Faker::Lorem.word }
    end
  end
end
