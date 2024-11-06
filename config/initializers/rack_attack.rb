class Rack::Attack
  ### 1. Redis Cache Konfigürasyonu ###
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
    url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')
  )

  ### 2. Rate Limiting Kuralları ###
  throttle('auth/ip', limit: 20, period: 5.minutes) do |req|
    if req.path == '/api/v1/login' && req.post?
      req.ip
    end
  end

  throttle('register/ip', limit: 5, period: 1.hour) do |req|
    if req.path == '/api/v1/register' && req.post?
      req.ip
    end
  end

  throttle('api/ip', limit: 1000, period: 1.minute) do |req|
    if req.path.start_with?('/api/')
      req.ip
    end
  end

  throttle('api/sensitive', limit: 60, period: 5.minutes) do |req|
    if req.path == '/api/v1/me' && req.get?
      req.ip
    end
  end

  ### 3. Throttled Response Handler ###
  Rack::Attack.throttled_responder = ->(request) {
    now = Time.now
    match_data = request.env['rack.attack.match_data']
    retry_after = (match_data[:period] - (now.to_i % match_data[:period]))

    [
      429,
      {
        'Content-Type' => 'application/json',
        'Retry-After' => retry_after.to_s
      },
      [{
        error: 'Rate limit exceeded. Please try again later.',
        retry_after: retry_after.to_s,
        limit: match_data[:limit],
        period: "#{match_data[:period]} seconds"
      }.to_json]
    ]
  }
end 