module Bandit
  module Generators

    class DashboardGenerator < Rails::Generators::Base
      desc "Create a bandit dashboard controller"
      source_root File.expand_path('../templates', __FILE__)

      def copy_controller
        copy_file 'bandit_controller.rb', 'app/controllers/bandit_controller.rb'
      end
      
      def copy_view
        directory 'dashboard/view', 'app/views/bandit'
        copy_file 'dashboard/bandit.html.erb', 'app/views/layouts/bandit.html.erb'
      end

      def copy_assets
        directory 'dashboard/js', 'public/javascripts/bandit'
        directory 'dashboard/css', 'public/stylesheets/bandit'
      end

      def message
        say "\n\tNow, add the following to your config/routes.rb file:"
        say "\t\tresources :bandit\n\n"
      end

   end

  end
end
