VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr"
  c.hook_into :webmock
end

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, /api.pusherapp.com/).to_return(status: 200, :body => "")
  end
end
