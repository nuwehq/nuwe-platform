FactoryGirl.define do

  factory :stat do
    log_time       { Date.current }
    resource_owner { rand(10e6) }
  

      factory :old_stat do
      log_time       { 31.days.ago }
      resource_owner { rand(10e6) }
    end
  end
end
