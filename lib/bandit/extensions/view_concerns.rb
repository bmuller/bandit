require 'active_support/concern'

module Bandit
  module ViewConcerns
    extend ActiveSupport::Concern

    # default choose is a session based choice
    def bandit_choose(exp)
      bandit_session_choose(exp)
    end

    # always choose something new and increase the participant count
    def bandit_simple_choose(exp)
      Bandit.get_experiment(exp).choose(nil)
    end

    # stick to one alternative for the entire browser session
    def bandit_session_choose(exp)
      name = "bandit_#{exp}".intern
      # choose url param with preference
      value = params[name].nil? ? cookies.signed[name] : params[name]
      # choose with default, and set cookie
      cookies.signed[name] = Bandit.get_experiment(exp).choose(value)
    end

    # stick to one alternative until user deletes cookies or changes browser
    def bandit_sticky_choose(exp)
      name = "bandit_#{exp}".intern
      # choose url param with preference
      value = params[name].nil? ? cookies.signed[name] : params[name]
      # sticky choice may outlast a given alternative
      alternative = if Bandit.get_experiment(exp).alternatives.include?(value)
                      value
                    else
                      Bandit.get_experiment(exp).choose(value)
                    end
      # re-set cookie
      cookies.permanent.signed[name] = alternative
    end
  end
end
