OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:moves] = OmniAuth::AuthHash.new({
  provider: "moves",
  uid: "36941906984592969",
  info: {"name"=>nil, "firstDate"=>"20140704"},
  credentials: {"token"=>"5aJOQD0d9th21L6M2mLwcV70h9cPXUXZw2n738MkM5y0HOluY5hsdQ3JD_K4749r", "expires"=>"true", "expires_at"=>"1425731708", "refresh_token"=>"fX9I4VS99CBhHO7k3N_0fn95lVOvdLJW130hi15q7j98iThbgU4Xj5M_oa7pW7Jy"}
})

OmniAuth.config.mock_auth[:fitbit] = OmniAuth::AuthHash.new({
  provider: "fitbit",
  uid: "2XBKND",
  credentials: {"token"=>"dcd012187cadbaac978da8ee16503dcc", "secret"=>"44a24363ea60abaf9f0d5bfeb0b91ae5"}
})

OmniAuth.config.mock_auth[:withings] = OmniAuth::AuthHash.new({
  provider: "withings",
  uid: "4767003", 
  credentials: {"token"=>"6c3089834342cbc61370fe85425639038b12c2388c4eb829318c837", "secret"=>"20705fe5f5c1c5f69e7755fb209d62238d7c7c6938377f5bb25566dc4ce045"}
})

OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  provider: "github",
  uid: @user.try(:uid) || "5464708",
  info: {"name"=>'Github user',"email"=>'github_user@example.com'}
})