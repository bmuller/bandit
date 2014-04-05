require File.join File.dirname(__FILE__), 'helper'
require File.join File.dirname(__FILE__), 'storage_test_base'

class YamlstoreStorageTest < Test::Unit::TestCase
  include StorageTestBase
  include SetupHelper

  def setup
    @storage_config = CONFIG['yamlstore_storage_config']
    cleanup
    Bandit.setup do |config|
      config.player = 'round_robin'
      config.storage = 'pstore'
      config.storage_config = @storage_config
    end

    @storage = Bandit.storage
  end

  def cleanup
    File.delete(@storage_config['file']) if File.exists?(@storage_config['file'])
  end

  def teardown
    cleanup
  end
end
