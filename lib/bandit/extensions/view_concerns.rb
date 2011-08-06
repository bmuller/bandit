require 'active_support/concern'

module Bandit
  module ViewConcerns
    extend ActiveSupport::Concern
  
    module ClassMethods
      
    end

    module InstanceMethods
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
