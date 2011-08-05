require 'bundler/gem_tasks'
require 'rdoc/task'

desc "Create documentation"
Rake::RDocTask.new("doc") { |rdoc|
  rdoc.title = "bandit - A multi-armed bandit optmization framework for Rails"
  rdoc.rdoc_dir = 'docs'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
}

