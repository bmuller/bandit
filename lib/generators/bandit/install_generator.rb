module Bandit
  module Generators

    class InstallGenerator < Rails::Generators::Base
      desc "Copy Bandit default config/initialization files"
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializers
        copy_file 'bandit.rb', 'config/initializers/bandit.rb'
      end

      def copy_config
        copy_file 'bandit.yml', 'config/bandit.yml'
      end
    end

  end
end
