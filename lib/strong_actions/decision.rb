module StrongActions
  class Decision

    def initialize(target)
      @target = target
    end

    def call(role, controller_name, action_name = nil, params = {})
      role_definition = StrongActions.config.role_definition(role)
      return true unless role_definition

      controller_value = role_definition[controller_name]
      return true if controller_value.nil?

      if controller_value.is_a?(Hash)
        action_name ||= 'index'
        action_value = controller_value[action_name]
      else
        action_value = controller_value
      end
      return true if action_value.nil?

      action_value = [action_value] unless action_value.is_a?(Array)
      action_value.each do |definition|
        next if definition === true
        return false unless definition

        role_object = role_object_for(role)
        return false unless role_object.instance_eval(definition)
      end

      true
    end

    def role_object_for(role)
      begin
         return @target.instance_eval(role)
      rescue NameError
        raise "role #{role} is not defined in controller"
      end
    end

  end
end