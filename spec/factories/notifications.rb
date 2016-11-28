FactoryGirl.define do

  factory :team_notification do
    user
    team

    text        { "Hi team!" }
  end

end
