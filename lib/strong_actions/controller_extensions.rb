module StrongActions
  module ControllerExtensions
    extend ActiveSupport::Concern

    included do
      if ::ActionPack::VERSION::MAJOR < 4
        before_filter :authorize_roles!
      else
        before_action :authorize_roles!
      end

      helper_method :available?
    end

    private

    def authorize_roles!
      StrongActions.config.roles.each do |role|
        unless judge(role, controller_name, action_name, params)
          message = "#{controller_name.capitalize}Controller##{action_name} is not permitted for role #{role}"
          raise StrongActions::ForbiddenAction.new(message)
        end
      end
    end

    def available?(controller_name, action_name = nil, params = {})
      action_name ||= 'index'

      StrongActions.config.roles.each do |role|
        return false unless judge(role, controller_name, action_name, params)
      end

      true
    end

    def judge(role, controller_name, action_name, params)
      role_definition = StrongActions.config.role_definition(role)
      return true unless role_definition

      begin
        role_object = eval(role)
      rescue NameError
        raise "role #{role} is not defined in controller"
      end

      controller_value = role_definition[controller_name]
      return true if controller_value.nil?

      if controller_value.is_a?(Hash)
        action_value = controller_value[action_name]
      else
        action_value = controller_value
      end
      return true if action_value.nil?

      action_value = [action_value] unless action_value.is_a?(Array)
      action_value.each do |definition|
        next if definition === true
        return false unless definition
        return false unless role_object.instance_eval(definition)
      end

      true
    end

  end
end