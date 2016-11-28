FactoryGirl.define do

  factory :ingredient do
    name          { Faker::Lorem.word }
    protein         { 0.010900 }
    carbs           { 0.080100 }
    kcal            { 0.890000 }
    fibre           { 0.026000 }
    fat_s           { 0.001120 }
    fat_u           { 0.001050 }
    salt            { 0.000025 }
    sugar           { 0.122300 }
    small_portion   { 60 }
    medium_portion  { 120 }
    large_portion   { 200 }

    factory :pasta_corn_cooked do
        name            { "Pasta corn cooked" }
        protein         { 0.026300 }
        carbs           { 0.231100 }
        kcal            { 1.260000 }
        fibre           { 0.048000 }
        fat_s           { 0.001020 }
        fat_u           { 0.005160 }
        salt            { 0.000000 }
        sugar           { 0.000000 }
        small_portion   { 60 }
        medium_portion  { 120 }
        large_portion   { 240 }
    end

    factory :carrots_raw do
        name            { "Carrots Raw" }
        protein         { 0.009300 }
        carbs           { 0.020400 }
        kcal            { 0.410000 }
        fibre           { 0.028000 }
        fat_s           { 0.000370 }
        fat_u           { 0.001310 }
        salt            { 0.001725 }
        sugar           { 0.047400 }
        small_portion   { 40 }
        medium_portion  { 80 }
        large_portion   { 120 }
    end

    factory :turkey_whl_meat do
        name            { "Turkey WHL Meat" }
        protein         { 0.290600 }
        carbs           { 0.000000 }
        kcal            { 1.590000 }
        fibre           { 0.000000 }
        fat_s           { 0.011320 }
        fat_u           { 0.022960 }
        salt            { 0.002525 }
        sugar           { 0.000000 }
        small_portion   { 60 }
        medium_portion  { 120 }
        large_portion   { 240 }
    end
        factory :banana_raw do
        name            { "Banana Raw" }
        protein         { 0.010900 }
        carbs           { 0.080100 }
        kcal            { 0.890000 }
        fibre           { 0.026000 }
        fat_s           { 0.001120 }
        fat_u           { 0.001050 }
        salt            { 0.000025 }
        sugar           { 0.122300 }
        small_portion   { 40 }
        medium_portion  { 80 }
        large_portion   { 120 }
    end
        factory :apple_raw_with_skin do
        name            { "Apple Raw With Skin" }
        protein         { 0.002600 }
        carbs           { 0.010200 }
        kcal            { 0.520000 }
        fibre           { 0.024000 }
        fat_s           { 0.000280 }
        fat_u           { 0.000580 }
        salt            { 0.024000 }
        sugar           { 0.103900 }
        small_portion   { 50 }
        medium_portion  { 120 }
        large_portion   { 250 }
    end
    factory :potatoes_raw_skin do
        name            { "Potatoes Raw Skin" }
        protein         { 0.025700 }
        carbs           { 0.099400 }
        kcal            { 0.580000 }
        fibre           { 0.025000 }
        fat_s           { 0.000260 }
        fat_u           { 0.000450 }
        salt            { 0.025000 }
        sugar           { 0.000000 }
        small_portion   { 50 }
        medium_portion  { 100 }
        large_portion   { 150 }
    end
    factory :egg_fresh_raw do
        name            { "Egg fresh raw" }
        protein         { 0.125600 }
        carbs           { 0.003500 }
        kcal            { 1.430000 }
        fibre           { 0.000000 }
        fat_s           { 0.031260 }
        fat_u           { 0.055690 }
        salt            { 0.003550 }
        sugar           { 0.003700 }
        small_portion   { 35 }
        medium_portion  { 70 }
        large_portion   { 140 }
    end
    factory :pepper do
        name            { "Pepper" }
        protein         { 0.109333 }
        carbs           { 0.331700 }
        kcal            { 2.883333 }
        fibre           { 0.262333 }
        fat_s           { 0.017593 }
        fat_u           { 0.047540 }
        salt            { 0.000458 }
        sugar           { 0.036600 }
        small_portion   { 1 }
        medium_portion  { 2 }
        large_portion   { 3 }
    end
    factory :salt do
        name            { "Salt" }
        protein         { 0.0 }
        carbs           { 0.0 }
        kcal            { 0.0 }
        fibre           { 0.0 }
        fat_s           { 0.0 }
        fat_u           { 0.0 }
        salt            { 0.96895 }
        sugar           { 0.0 }
        small_portion   { 1 }
        medium_portion  { 2 }
        large_portion   { 3 }
    end
    factory :olive_oil do
        name            { "Olive Oil" }
        protein         { 0.0 }
        carbs           { 0.0 }
        kcal            { 8.84 }
        fibre           { 0.0 }
        fat_s           { 0.13808 }
        fat_u           { 0.83484 }
        salt            { 0.96895 }
        sugar           { 0.0 }
        small_portion   { 5 }
        medium_portion  { 10 }
        large_portion   { 20 }
    end
    factory :rice do
        name            { "Rice" }
        protein         { 0.0282 }
        carbs           { 0.21845 }
        kcal            { 1.0975 }
        fibre           { 0.0125 }
        fat_s           { 0.000862 }
        fat_u           { 0.00304 }
        salt            { 0.000088 }
        sugar           { 0.00295 }
        small_portion   { 60 }
        medium_portion  { 120 }
        large_portion   { 200 }
    end
    factory :beef do
        name            { "Beef" }
        protein         { 0.180525 }
        carbs           { 0.0 }
        kcal            { 2.29125 }
        fibre           { 0.0 }
        fat_s           { 0.067362 }
        fat_u           { 0.075469 }
        salt            { 0.001653 }
        sugar           { 0.0 }
        small_portion   { 60 }
        medium_portion  { 120 }
        large_portion   { 200 }
    end
    factory :mushrooms do
        name            { "Mushrooms" }
        protein         { 0.02605 }
        carbs           { 0.017338 }
        kcal            { 0.275 }
        fibre           { 0.018375 }
        fat_s           { 0.000451 }
        fat_u           { 0.001659 }
        salt            { 0.000225 }
        sugar           { 0.015875 }
        small_portion   { 45 }
        medium_portion  { 90 }
        large_portion   { 200 }
    end
    factory :peppers do
        name            { "Peppers" }
        protein         { 0.008833 }
        carbs           { 0.009033 }
        kcal            { 0.266667 }
        fibre           { 0.016 }
        fat_s           { 0.000437 }
        fat_u           { 0.001357 }
        salt            { 0.000067 }
        sugar           { 0.033767 }
        small_portion   { 45 }
        medium_portion  { 90 }
        large_portion   { 200 }
    end
    factory :tomatoes do
        name            { "Tomatoes" }
        protein         { 0.032317 }
        carbs           { 0.0136 }
        kcal            { 0.608333 }
        fibre           { 0.030833 }
        fat_s           { 0.00093 }
        fat_u           { 0.003548 }
        salt            { 0.002292 }
        sugar           { 0.088967 }
        small_portion   { 45 }
        medium_portion  { 90 }
        large_portion   { 200 }
    end
    factory :squash do
        name            { "Squash" }
        protein         { 0.011443 }
        carbs           { 0.023114 }
        kcal            { 0.29 }
        fibre           { 0.017429 }
        fat_s           { 0.000637 }
        fat_u           { 0.001346 }
        salt            { 0.000132 }
        sugar           { 0.027471 }
        small_portion   { 75 }
        medium_portion  { 150 }
        large_portion   { 300 }
    end
    factory :carrot do
        name            { "Carrot" }
        protein         { 0.0093 }
        carbs           { 0.0204 }
        kcal            { 0.41 }
        fibre           { 0.028 }
        fat_s           { 0.00037 }
        fat_u           { 0.00131 }
        salt            { 0.001725 }
        sugar           { 0.0474 }
        small_portion   { 60 }
        medium_portion  { 120 }
        large_portion   { 200 }
    end
    factory :potato do
        name            { "Potato" }
        protein         { 0.019033 }
        carbs           { 0.1374 }
        kcal            { 0.726667 }
        fibre           { 0.018 }
        fat_s           { 0.00029 }
        fat_u           { 0.000507 }
        salt            { 0.000325 }
        sugar           { 0.0102 }
        small_portion   { 75 }
        medium_portion  { 150 }
        large_portion   { 300 }
    end
    factory :onion_leeks do
        name            { "Onion/Leeks" }
        protein         { 0.01426 }
        carbs           { 0.03562 }
        kcal            { 0.398 }
        fibre           { 0.0188 }
        fat_s           { 0.000362 }
        fat_u           { 0.001026 }
        salt            { 0.000325 }
        sugar           { 0.03534 }
        small_portion   { 40 }
        medium_portion  { 80 }
        large_portion   { 160 }
    end

    factory :usda_ingredient do
      name                  { "CHEESE,COTTAGE,CRMD,W/FRUIT" }
      protein               { 0.010900 }
      carbs                 { 0.080100 }
      kcal                  { 0.890000 }
      fibre                 { 0.026000 }
      fat_s                 { 0.001120 }
      fat_u                 { 0.001050 }
      salt                  { 0.000025 }
      sugar                 { 0.122300 }
      ingredient_group_id   {  }
      small_portion         {  }
      medium_portion        { 113 }
      large_portion         { 226 }
      proximates            { {"water"=>"0.796400", "energy"=>"0.009700", "sugars"=>"0.023800", "protein"=>"0.106900", "total_lipid"=>"0.038500", "total_dietary_fibre"=>"0.002000", "carbohydrate_by_difference"=>"0.046100"} }
      minerals              { {"iron"=>"0.001600", "zinc"=>"0.003300", "sodium"=>"3.440000", "calcium"=>"0.530000", "magnesium"=>"0.070000", "potassium"=>"0.900000", "phosphorus"=>"1.130000"} }
      vitamins              { {"thiamin"=>"0.000330", "vitamin_d"=>"NULL", "vitamin_k"=>"NULL", "folate_dfe"=>"NULL", "riboflavin"=>"0.001420", "vitamin_b6"=>"0.000680", "vitamin_b12"=>"NULL", "vitamin_a_iu"=>"1.460000", "vitamin_a_rae"=>"0.380000", "vitamin_e_alpha_tocopheral"=>"0.000400", "vitamin_c_total_ascorbic_acid"=>"0.014000"} }
      lipids                { {"cholesterol"=>"0.130000", "fatty_acids_total_saturated"=>"0.023110", "fatty_acids_total_monounsaturated"=>"0.010360", "fatty_acids_total_polyunsaturated"=>"0.001240"} }
      portions              { {"4.0 oz"=>"113.0", "1.0 cup (not packed)"=>"226.0"}}
    end

    factory :cane_syrup do
      name                  { "SYRUP,CANE" }
      protein               { 0.000000 }
      carbs                 { 0.731400 }
      kcal                  { 0.026900 }
      fibre                 { 0.000000 }
      fat_s                 { 0.000000 }
      fat_u                 { 0.000000 }
      salt                  { 0.580000 }
      sugar                 { 0.732000 }
      ingredient_group_id   {  }
      small_portion         {  }
      medium_portion        {  }
      large_portion         {  }
      proximates            { {water: "0.260000", energy: "0.026900", protein: "0.000000", total_lipid: "0.000000", carbohydrate_by_difference: "0.731400", total_dietary_fibre: "0.000000", sugars: "0.732000"} }
      minerals              { {calcium: "0.130000", iron: "0.036000", magnesium: "0.100000", phosphorus: "0.080000", potassium: "0.630000", sodium: "0.580000", zinc: "0.001900"} }
      vitamins              { {vitamin_c_total_ascorbic_acid: "0.000000", thiamin: "0.000120", riboflavin: "0.000240", vitamin_b6: "0.001120", folate_dfe: "NULL", vitamin_b12: "NULL", vitamin_a_rae: "0.020000", vitamin_a_iu: "0.050000", vitamin_e_alpha_tocopheral: "0.000000", vitamin_d: "NULL", vitamin_k: "NULL"} }
      lipids                { {fatty_acids_total_saturated: "0.000000", fatty_acids_total_monounsaturated: "0.000000", fatty_acids_total_polyunsaturated: "0.000000", cholesterol: "0.000000"} }
      portions              { {} }
    end

    factory :simple_ingredient do
      name                 { "Banana" }
      protein              { 0.01426 }
      carbs                { 0.03562 }
      kcal                 { 0.398 }
      fibre                { 0.0188 }
      fat_s                { 0.000362 }
      fat_u                { 0.001026 }
      salt                 { 0.000325 }
      sugar                { 0.03534 }
      small_portion        { 40 }
      medium_portion       { 80 }
      large_portion        { 160 }
      proximates           { {} }
      minerals             { {} }
      vitamins             { {} }
      lipids               { {} }
    end

    factory :orange do
      name                 { "Orange" }
      protein              { 0.007400 }
      carbs                { 0.014800 }
      kcal                 { 0.467000 }
      fibre                { 0.010900 }
      fat_s                { 0.000183 }
      fat_u                { 0.000616 }
      salt                 { 0.000048 }
      sugar                { 0.088530 }
      small_portion        { 60 }
      medium_portion       { 120 }
      large_portion        { 200 }
      proximates           { {} }
      minerals             { {} }
      vitamins             { {} }
      lipids               { {} }
    end
  end
end
