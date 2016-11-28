FactoryGirl.define do

  factory :oauth_token, :class => Doorkeeper::AccessToken do
    resource_owner_id     { :oauth_user_id }

    factory :oauth_gorby do
      token     "585ac82a496805823b33459555c7eb2ef19f39fe55ab6e1aedd14be962e10c8a"
    end
  end 

end