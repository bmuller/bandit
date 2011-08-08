module Bandit
  module Generators

    class DashboardGenerator < Rails::Generators::Base
      desc "Create a bandit dashboard controller"
      source_root File.expand_path('../templates', __FILE__)

      def copy_controller
        copy_file 'bandit_controller.rb', 'app/controllers/bandit_controller.rb'
      end
      
      def copy_view
        copy_file 'dashboard/index.html.erb', 'app/views/bandit/index.html.erb'
        copy_file 'dashboard/bandit.html.erb', 'app/views/layouts/bandit.html.erb'
      end

      def copy_assets
        directory 'dashboard/js', 'public/javascripts/bandit'
        directory 'dashboard/css', 'public/css/bandit'
      end

      def message
        say "\n\tNow, add the following to your config/routes.rb file:"
        say "\t\tmatch 'bandit' => 'bandit#index'\n\n"
      end

   end

  end
end
