require 'active_support/concern'

module Bandit
  module ControllerConcerns
    extend ActiveSupport::Concern
  
    module ClassMethods
      
    end

    module InstanceMethods
      def bandit_convert!(exp, alt=nil, count=1)
        cookiename = "bandit_#{exp}".intern
        alt ||= cookies.signed[cookiename]
        unless alt.nil?
          Bandit.get_experiment(exp).convert!(alt, count)
          # delete cookie so we don't double track
          cookies.delete(cookiename)
        end
      end

      def bandit_choose(exp)
        name = "bandit_#{exp}".intern

        # choose url param with preference
        value = params[name].nil? ? cookies.signed[name] : params[name]

        # choose with default, and set cookie
        cookies.signed[name] = Bandit.get_experiment(exp).choose(value)
      end
    end

  end
end
