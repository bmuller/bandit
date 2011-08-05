# Use this setup block to configure all options for Bandit.
Bandit.setup do |config|
  yml = YAML.load_file("#{Rails.root}/config/bandit.yml")[Rails.env]

  config.player = yml['player']
  config.player_config = yml['player_config']
  
  config.storage = yml['storage']
  config.storage = yml['storage_config']
end

# Create your metrics here
# m = Metric.new :name => 'clicks', :description => 'number of people who clicked'

# Create your experiments here
# e = Experiment.new :title => 'awesome experiment', :description => 'test button sizes'
# e.alternatives = [ 20, 30, 40 ]
# e.metric = m

# That's all!
