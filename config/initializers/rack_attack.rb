Rack::Attack.throttle('api auth', limit: 5, period: 1.minute) do |req|
  if req.post? && req.path =~ /\/v\d\/auth\.json/
    req.ip
  end
end

Rack::Attack.throttle('api/v1/search', limit: 5, period: 10.seconds) do |req|
  if req.path =~ /v1\/search/
    req.ip
  end
end

Rack::Attack.throttle('api/v1/reset_password', limit: 1, period: 10.seconds) do |req|
  if req.path =~ /v1\/reset_password/
    req.ip
  end
end

Rack::Attack.throttle('api/v1/team/notification', limit: 1, period: 1.minute) do |req|
  if req.post? && req.path =~ /\/v\d\/teams\/\d+\/notifications/
    # OPTIMIZE only block by params[:team_id]
    req.ip
  end
end

Rack::Attack.throttled_response = lambda do |env|
  retry_after = env['rack.attack.match_data'][:period] rescue nil
  [
    429,
    {'Content-Type' => "application/json", 'Retry-After' => retry_after.to_s},
    [{error: {message: "Slow down, cowboy."}}.to_json]
  ]
end
