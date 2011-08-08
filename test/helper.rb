require 'rubygems'
require 'test/unit'
require 'yaml'

$:.unshift(File.join File.dirname(__FILE__), '..', 'lib')
require 'bandit'

CONFIG = YAML.load_file File.join(File.dirname(__FILE__), "config.yml")

module SetupHelper
  def new_metric
    Bandit::Metric.create(:clicks, "A count of clicks on the purchase page.")
  end

  def new_experiment
    Bandit::Experiment.create(:exp_test) { |exp| 
      exp.alternatives = [10,20,30,40]
      exp.metric = new_metric
      exp.title = "A Test Exp"
      exp.description = "Desc"
    }
  end
end
