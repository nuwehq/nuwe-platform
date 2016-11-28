FactoryGirl.define do

  factory :product do
    name         { "Milk Chocolate Fine" }
    brand        { "Cadbury" }
    upc          { "034000040254" }
    weight       { "3.5 oz"}
    serving_size { "7 blocks"}
    type         { "snack"}
    kcal         { "200.0"}
    protein      { "3.0"}
    fibre        { "1.0" }
    carbs        { "23.0"}
    fat_u        { "0.0"}
    fat_s        { "7.0" }
    salt         { "40.0" }
    sugar        { "22.0" }

    factory :product_with_place do
      after(:create) do |product|
        product.places.create name: "Iceland Foods ltd", address: "Adress United Kingdom", lat: "50.8571601", lon: "-2.1645891"
      end

      factory :dark_chocolate do
        name         { "Dark Chocolate Fine" }
        brand        { "Cadbury" }
        upc          { "034000040255" }
        weight       { "3.5 oz"}
        serving_size { "7 blocks"}
        type         { "snack"}
        kcal         { "200.0"}
        protein      { "3.0"}
        fibre        { "1.0" }
        carbs        { "23.0"}
        fat_u        { "0.0"}
        fat_s        { "7.0" }
        salt         { "40.0" }
        sugar        { "22.0" }
      end

      factory :cheese_dip do
        name         { "Cheese Dip Original" }
        brand        { "Cheez Whiz" }
        upc          { "021000626793" }
        weight       { "15 oz" }
        serving_size { "2 tablespoon" }
        kcal         { "90" }
        protein      { "3" }
        fibre        { "0" }
        carbs        { "4" }
        fat_u        { "0" }
        fat_s        { "1.5" }
        salt         { "440" }
        sugar        { "2" }
      end

    end
  end

end
