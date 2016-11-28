FactoryGirl.define do

  factory :access_grant, class: "Doorkeeper::AccessGrant" do
    expires_in          { 60.days }
    redirect_uri        { Faker::Internet.url }
    resource_owner_id   { rand(10e6) }
  end

end
