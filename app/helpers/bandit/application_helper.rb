module Bandit
  module ApplicationHelper
    def storage_name
      Bandit.config.storage.titleize
    end

    def round_percent(percent)
      (percent * 100).round / 100.0
    end

    def player_name
      Bandit.config.player.titleize
    end

    def storage_config
      c = Bandit.config.storage_config.map { |k,v| "#{k}: #{v}" }.join(", ")
      c.blank? ? "" : "(#{c})"
    end

    def player_config
      c = Bandit.config.player_config.map { |k,v| "#{k}: #{v}" }.join(", ")
      c.blank? ? "" : "(#{c})"
    end
  end
end
