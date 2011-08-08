require File.join File.dirname(__FILE__), 'helper'
require File.join File.dirname(__FILE__), 'storage_test_base'

class MemoryStorageTest < Test::Unit::TestCase
  include StorageTestBase
  include SetupHelper

  def setup
    Bandit.setup do |config|
      config.player = "round_robin"
      config.storage = 'memory'
    end
    
    @storage = Bandit.storage
  end
end
