module Bandit
  class UnknownStorageEngineError < RuntimeError
  end

  class UnknownPlayerEngineError < RuntimeError
  end

  class MissingConfigurationError < ArgumentError
  end
end
