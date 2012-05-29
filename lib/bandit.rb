require "bandit/version"
require "bandit/exceptions"
require "bandit/config"
require "bandit/experiment"
require "bandit/date_hour"
require "bandit/memoizable"

require "bandit/players/base"
require "bandit/players/round_robin"
require "bandit/players/epsilon_greedy"

require "bandit/storage/base"
require "bandit/storage/memory"
require "bandit/storage/memcache"
require "bandit/storage/redis"
require "bandit/storage/dalli"

require "bandit/extensions/controller_concerns"
require "bandit/extensions/array"
require "bandit/extensions/view_concerns"
require "bandit/extensions/time"
require "bandit/extensions/string"

module Bandit
  @@storage_failure_at = nil

  def self.config
    @config ||= Config.new
  end

  def self.setup(&block)
    yield config
    config.check!
    # intern keys in storage config
    config.storage_config = config.storage_config.inject({}) { |n,o| n[o.first.intern] = o.last; n }
  end

  def self.storage
    # try using configured storage at least once every 5 minutes until resolved
    if @@storage_failure_at.nil? or (Time.now.to_i - @@storage_failure_at) > 300
      @storage ||= BaseStorage.get_storage(Bandit.config.storage.intern, Bandit.config.storage_config)
    else
      Rails.logger.warn "storage failure detected #{Time.now.to_i - @@storage_failure_at} seconds ago - using memory storage for 5 minutes"
      BaseStorage.get_storage(:memory, Bandit.config.storage_config)
    end
  end

  def self.player
    @player ||= BasePlayer.get_player(Bandit.config.player.intern, Bandit.config.player_config)
  end

  def self.storage_failed!
    @@storage_failure_at = Time.now.to_i
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
