require "redis_fragment_cache/version"
require "redis_fragment_cache/configuration"

module RedisFragmentCache
  # Your code goes here...
  class << self

    def register!
      require 'redis_fragment_cache/register'
    end

    def configure(&block)
      yield(configuration)
    end

    def configuration
      @_configuration ||= Configuration.new
    end

    def reset_configuration!
      @_configuration = nil
    end
  end
end
