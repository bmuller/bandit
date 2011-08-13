module Bandit
  module Memoizable
    # remember a block for some time (60 seconds by default)
    def memoize(key, time=60)
      @memoized ||= {}
      @memoized_times ||= {}
      now = Time.now.to_i
      if not @memoized.has_key?(key) or now > @memoized_times[key]
        @memoized[key] = yield
        @memoized_times[key] = now + time
      end
      @memoized[key]
    end
  end
end
