FactoryGirl.define do

  factory :breakdown, class: "Nutrition::Breakdown" do
    date          { Date.current }
    kcal_g        { "381.6" }
    kcal_perc     { "12.274043100675" }
    protein_g     { "69.744" }
    protein_perc  { "68.8168281" }
    fibre_g       { "0.0" }
    fibre_perc    { "0.0" }
    carbs_g       { "0.0" }
    carbs_perc    { "0.0"}
    fat_u_g       { "5.5104"}
    fat_u_perc    { "7.9446392464089505100284" }
    fat_s_g       { "2.7168" }
    fat_s_perc    { "8.4725467436754452830" }
    salt_g        { "0.606" }
    salt_perc     { "10.1" }
    sugar_g       { "0.0" }
    sugar_perc    { "0.0" }

    factory :breakdown_older do
      date          { Date.yesterday }
      kcal_g        { "38.6" }
      kcal_perc     { "12.27" }
      protein_g     { "69.744" }
      protein_perc  { "68.816" }
      fibre_g       { "0.0" }
      fibre_perc    { "0.0" }
      carbs_g       { "0.0" }
      carbs_perc    { "0.0"}
      fat_u_g       { "5.5104"}
      fat_u_perc    { "7.944" }
      fat_s_g       { "2.7168" }
      fat_s_perc    { "8.472" }
      salt_g        { "0.606" }
      salt_perc     { "10.1" }
      sugar_g       { "0.0" }
      sugar_perc    { "0.0" }
    end 
  end

end