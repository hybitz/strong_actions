module StrongActions
  module ControllerExtentions
    extend ActiveSupport::Concern

    included do
      helper_method :available?
    end

    private

    def available?(controller_name, action_name = nil, params = {})
      action_name ||= 'index'

      StringActions.config.roles.each do |role|
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
          unless role.instance_eval(definition)
            message = "#{controller_name}##{action_name} is not permitted for #{role}"
            raise StrongActions::ForbiddenAction.new(message)
          end 
        end
      end

      true
    end

  end
end