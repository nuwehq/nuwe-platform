# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    first_name          { Faker::Name.first_name }
    last_name           { Faker::Name.last_name }
    sex                 { %w(M F).sample }
    birth_date          "2014-03-24"
    activity            4

    factory :facebook_profile do
      facebook_id       "54265378123233232"
    end

    factory :profile_female do
    first_name          { "Lady" }
    last_name           { Faker::Name.last_name }
    sex                 { "F" }
    birth_date          { "1980-08-01" }
    activity            { 2 }   
    title               { "Ruby on Rails Developer"}
    end

    factory :profile_sergio do
    first_name          { "Sergio" }
    last_name           { Faker::Name.last_name }
    sex                 { "M" }
    birth_date          { "1976-08-01" }
    activity            { 4 }
    weight              { 85000 }
    height              { 1820 }    
    end
    
    factory :profile_giulia do
    first_name          { "Giulia" }
    last_name           { Faker::Name.last_name }
    sex                 { "F" }
    birth_date          { "1981-08-01" }
    activity            { 2 }
    weight              { 60000 }
    height              { 1800 }    
    end


  end
end
