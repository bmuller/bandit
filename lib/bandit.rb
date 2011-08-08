require "bandit/version"
require "bandit/exceptions"
require "bandit/config"
require "bandit/experiment"
require "bandit/date_hour"

require "bandit/players/base"
require "bandit/players/round_robin"

require "bandit/storage/base"
require "bandit/storage/memory"

require "bandit/extensions/controller_concerns"
require "bandit/extensions/view_concerns"
require "bandit/extensions/time"

module Bandit
  def self.config
    @config ||= Config.new
  end

  def self.setup(&block)
    yield config
    config.check!
  end  

  def self.storage
    @storage ||= BaseStorage.get_storage(Bandit.config.storage.intern, Bandit.config.storage_config)
  end

  def self.player
    @player ||= BasePlayer.get_player(Bandit.config.player.intern, Bandit.config.player_config)
  end

  def self.get_experiment(name)
    exp = Experiment.instances.select { |e| e.name == name } 
    exp.length > 0 ? exp.first : nil
  end

  def self.experiments
    Experiment.instances
  end
end

require 'action_controller'
ActionController::Base.send :include, Bandit::ControllerConcerns

require 'action_view'
ActionView::Base.send :include, Bandit::ViewConcerns
