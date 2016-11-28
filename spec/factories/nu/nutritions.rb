FactoryGirl.define do

  factory :nu_nutrition, class: "Nu::Nutrition" do
    user
    date              { Date.current }
    score             { 39 }
  end

end
