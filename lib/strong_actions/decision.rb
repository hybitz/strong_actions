module StrongActions
  class Decision

    def initialize(target)
      @target = target
    end

    def call(role, controller_path, action_name = nil, params = {})
      action_name ||= 'index'
      role_definition = StrongActions.config.role_definition(role)
      return true unless role_definition

      controller_names_for(controller_path).each do |controller_name|
        controller_value = role_definition[controller_name]
        next if controller_value.nil?

        if controller_value.is_a?(Hash)
          action_value = controller_value[action_name]
        else
          action_value = controller_value
        end
        next if action_value.nil?

        action_values = Array(action_value)
        action_values.each do |definition|
          next if definition === true
          return false if definition === false

          role_object = role_object_for(role)
          return false unless role_object.instance_eval(definition)
        end

        break
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

    def controller_names_for(controller_path)
      ret = []

      path_elements = controller_path.split('/')
      if path_elements.size == 1
        ret = path_elements
      else
        path_elements.each_with_index do |path_element, i|
          ret << ret.last.to_s + path_element + (i < path_elements.size - 1 ? '/' : '')
        end
        ret.reverse!
      end

      ret
    end
    
  end
end