module Bandit

  class Config
    def self.required_fields
      [:storage, :player]
    end
    
    # storage should be name of storage engine
    attr_accessor :storage

    # storage_config should be hash of storage config values
    attr_accessor :storage_config

    # player should be name of player
    attr_accessor :player

    # player_config should be hash of player config values
    attr_accessor :player_config

    def check!
      self.class.required_fields.each do |required_field|
        unless send(required_field)
          raise MissingConfigurationError, "#{required_field} must be set"
        end
      end

      @storage_config ||= {}
      @player_config ||= {}
    end

  end

end
