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
        role_definition = StrongActions.config.role_definition(role)
        next unless role_definition

        raise "role #{role} is not defined in controller" unless defined?(role)
        role_object = eval(role)

        controller_value = role_definition[controller_name]
        next if controller_value.nil?

        if controller_value.is_a?(Hash)
          action_value = controller_value[action_name]
        else
          action_value = controller_value
        end
        next if action_value.nil?

        action_value = [action_value] unless action_value.is_a?(Array)
        action_value.each do |definition|
          return false unless definition
          return false unless role_object.instance_eval(definition)
        end
      end

      true
    end

  end
end