FactoryGirl.define do

  factory :app do

    user

    provider            "omniauth"
    uid                 "536947327452317"

    factory :humanapi do
      uid               "af5c505d1ff8d3b05e60ad40b8e597bc"
      provider          "humanapi"
      credentials       {{"humanId"=>"7733298fcd814d52e1a4f49b276303b7", "clientId"=>"1bfb6cb4e609e8ab4200de1ccafed5b7d1752b89", "accessToken"=>"uIqDtL-R3Jtl9niDWVhSuxrJFtc=OQRokuvMf0cd6cc4189b7c2ab0653fce6cb4bf234e0aebb7f44979084febc6929ff85bcc26ab19725e64e93ffa00d58d7cef61f5549ddd3f57d8bf73d6aa5542e609eaf77dabb54d32807fe02675822765115d433bf4ee6d53fe2659eb850bba0685f9046a6844b8953fc9cd17876e6a83ebaa95", "publicToken"=>"b8cd7b7e1ef0ce68290ba84498872e3f"}}
    end

    factory :moves_app do
      uid               "37115775221975143"
      provider          "moves"
      credentials       {{"token"=>"OhFuqJ5Yk7Uu3IANbOzt93U000l8vWaW3Quq7sND49TabUHM64ScM0OWmeHQO5W1", "expires"=>"true", "expires_at"=>"1425731708", "refresh_token"=>"xvApFpMAk5VXbl4jH2z7wC4Ud6CPG65y6Fe2Cf7_cU9OY37ZRHZ8O0nVq786ujOe"}}
    end

    factory :fitbit_app do
      uid               "2XBKND"
      provider          "fitbit"
      credentials       {{"token"=>"dcd012187cadbaac978da8ee16503dcc", "secret"=>"44a24363ea60abaf9f0d5bfeb0b91ae5"}}
    end


    factory :withings_app do
      uid               "4767003"
      provider          "withings"
      credentials       {{"token"=>"6c3089834342cbc61370fe85425639038b12c2388c4eb829318c837", "secret"=>"20705fe5f5c1c5f69e7755fb209d62238d7c7c6938377f5bb25566dc4ce045"}}
    end
  end

end
