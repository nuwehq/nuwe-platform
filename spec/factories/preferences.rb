FactoryGirl.define do

  factory :units_preference, class: "Preference" do
    user
    name        "units"
    value       "imperial"
  end

end
