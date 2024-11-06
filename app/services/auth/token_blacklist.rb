module Auth
  class TokenBlacklist
    class << self
      def invalidate(token)
        return false unless token
        
        # Store the token in Redis with 24 hour expiry (matching JWT expiry)
        REDIS.setex("blacklisted_token:#{token}", 24.hours.to_i, Time.current.to_i)
      end

      def invalid?(token)
        return true unless token
        REDIS.exists?("blacklisted_token:#{token}")
      end
    end
  end
end 