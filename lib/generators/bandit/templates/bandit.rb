# Use this setup block to configure all options for Bandit.
Bandit.setup do |config|
  yml = YAML.load_file("#{Rails.root}/config/bandit.yml")[Rails.env]

  config.player = yml['player']
  config.player_config = yml['player_config']
  
  config.storage = yml['storage']
  config.storage_config = yml['storage_config']
end

# Create your experiments here - like this:
# Bandit::Experiment.create(:click_test) { |exp|
#   exp.alternatives = [ 20, 30, 40 ]
#   exp.title = "Click Test"
#   exp.description = "A test of clicks on purchase page with varying link sizes."
# }

