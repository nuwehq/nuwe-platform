FactoryGirl.define do

  factory :service do
    service_category

    factory :factual_upc_service do
      name                { "Factual UPC" }
      lib_name            { "factual_upc" }
    end
    factory :factual_places_service do
      name                { "Factual Places" }
      lib_name            { "factual_places" }
    end
    factory :nuwe_places_service do
      name                { "Nuwe Places" }
      lib_name            { "nuwe_places" }
    end

    factory :usda_service do
      name                { "Nuwe Ingredients" }
      lib_name            { "nuwe_ingredients" }
    end
    factory :nuwe_meals_service do
      name                { "Nuwe Meals" }
      lib_name            { "nuwe_meals" }
    end
     factory :nuwe_standard_security do
      name                { "Nuwe Security - Standard" }
      lib_name            { "nuwe_sec_standard" }
    end
    factory :nuscore_service do
      name                { "Nuscore"}
      lib_name            { "nuscore"}
    end
    factory :nuwe_nutrition_service do
      name                { "Nuwe Nutrition" }
      lib_name            { "nuwe_nutrition" }
    end
    factory :nuwe_teams_service do
      name                {"Nuwe Teams" }
      lib_name            {"nuwe_teams" }
    end
  end

end
