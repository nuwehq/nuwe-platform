FactoryGirl.define do

  factory :user do

    password                    { "railsisomakase" }
    password_confirmation       { "railsisomakase" }
    email                       { Faker::Internet.email }

    factory :v1_user do
      md5_password              "e53522351c4cfce1b2c3ecb3f4dbf2cd" # letmeinplease

      # v1 users will never sign up, so do not use the interactor, just generate the model.
      initialize_with do
        new
      end
    end

    factory :v2_user do
      password                    "letmeinplease"
      password_confirmation       "letmeinplease"
    end

    factory :developer do
    end

    factory :oauth_user do
    end

    factory :iot_user do
      email                       "iot_user@example.com"
    end

    factory :old_user_github do
      email                       "github_user@example.com"
    end

    factory :admin do

      after(:create) do |user|
        user.update_attribute :roles, ['admin']
        user.update_attribute :created_at, 1.day.ago
        user.update_attribute :updated_at, 1.day.ago
      end
    end

    ## !! Overriding the initializer !! ##
    #
    # We do this because the SignUp interactor is critical to how users are created.
    # But it means you can't FactoryGirl.create a user and expect that it just works.
    # If you need to set various attributes on a factory girl'd user, you must do
    # it separately from the .create.
    initialize_with do
      VCR.use_cassette "users/create" do
        SignUp.call(attributes.merge(root_url: "http://test.example.com/")).user
      end
    end

  end

end
