module StrongActions
  module ControllerExtentions
    extend ActiveSupport::Concern

    included do
      before_action :authorize_roles!
      helper_method :available?
    end

    private

    def authorize_roles!
      unless available?(controller_name, action_name, params)
        message = "#{controller_name}##{action_name} is not permitted"
        raise StrongActions::ForbiddenAction.new(message)
      end
    end

    def available?(controller_name, action_name = nil, params = {})
      action_name ||= 'index'

      StrongActions.config.roles.each do |role|
        role_object = eval(role)
        raise "role #{role} is not defined in controller" unless role_object

        role_definition = StrongActions.config.role_definition(role)
        next unless role_definition

        controller_value = role_definition[controller_name]
        next unless controller_value

        if controller_value.is_a?(Hash)
          action_value = controller_value[action_name]
        else
          action_value = controller_value
        end
        next unless action_value

        action_value = [action_value] unless action_value.is_a?(Array)
        action_value.each do |definition|
          return false unless role.instance_eval(definition)
        end
      end

      true
    end

  end
end