require 'active_support/concern'

module Bandit
  module ControllerConcerns
    extend ActiveSupport::Concern

    # default convert is a session based conversion
    def bandit_convert!(exp, alt=nil, count=1)
      bandit_session_convert!(exp, alt, count)
    end

    # look mum, no cookies
    def bandit_simple_convert!(exp, alt, count=1)
      Bandit.get_experiment(exp).convert!(alt, count)
    end

    # expects a session cookie, deletes it, will convert again
    def bandit_session_convert!(exp, alt=nil, count=1)
      cookiename = "bandit_#{exp}".intern
      cookiename_converted = "bandit_#{exp}_converted".intern
      alt ||= cookies.signed[cookiename]
      unless alt.nil? or cookies.signed[cookiename_converted]
        Bandit.get_experiment(exp).convert!(alt, count)
        cookies.delete(cookiename)
      end
    end

    # creates a _converted cookie, prevents multiple conversions
    def bandit_sticky_convert!(exp, alt=nil, count=1)
      cookiename = "bandit_#{exp}".intern
      cookiename_converted = "bandit_#{exp}_converted".intern
      alt ||= cookies.signed[cookiename]
      unless alt.nil? or cookies.signed[cookiename_converted]
        cookies.permanent.signed[cookiename_converted] = "true"
        Bandit.get_experiment(exp).convert!(alt, count)
      end
    end
  end
end
