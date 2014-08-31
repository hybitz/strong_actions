module StrongActions
  class Railtie < ::Rails::Railtie

    initializer 'strong_actions' do
      ActiveSupport.on_load :action_controller do
        require 'strong_actions/controller_extentions'
        include StrongActions::ControllerExtentions
      end
    end

  end
end
