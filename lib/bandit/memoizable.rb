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
  
    module ClassMethods
      def memoize_method(method, time=60)
        original_method = "unmemoized_#{method}_#{Time.now.to_i}"
        alias_method original_method, method
        module_eval(<<-EVAL, __FILE__, __LINE__)
        def #{method}(*args, &block)
          memoize(:#{original_method}, #{time}) { send(:#{original_method}, *args, &block) }
        end
        EVAL
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
