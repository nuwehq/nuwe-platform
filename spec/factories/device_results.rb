FactoryGirl.define do

  factory :device_result do
    data {{"temperature"=>"15","humidity"=>"22","created_at"=>"2015-09-23T09:07:51.628Z"}}
    date { Date.today }
    factory :device_result_yesterday do
      date { Date.yesterday }
      filename {"yesterday"}
      data {{"temperature"=>"15","humidity"=>"22","created_at"=>"2015-10-23T09:07:51.628Z"}}
    end
    factory :device_result_correct_filename do
      filename {"correct_filename"}
      data {{"temperature"=>"15","humidity"=>"22","created_at"=>"2015-10-23T09:07:51.628Z"}}
    end
  end

end
