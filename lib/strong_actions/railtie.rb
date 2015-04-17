module StrongActions
  class Railtie < ::Rails::Railtie

    initializer 'strong_actions' do
      ActiveSupport.on_load :action_controller do
        include StrongActions::Controller
      end
    end

  end
end
