require 'rails'

module Bandit
  class Engine < Rails::Engine
    isolate_namespace Bandit
    engine_name 'bandit'
  end
end
