require_relative 'decision'

module StrongActions
  module Controller
    extend ActiveSupport::Concern

    included do
      before_action :authorize_roles!
      helper_method :available?
    end

    private

    def authorize_roles!
      StrongActions.config.roles.each do |role|
        unless judge(role, controller_path, action_name, params)
          message = "#{controller_path.classify}Controller##{action_name} is not permitted for role #{role}"
          raise StrongActions::ForbiddenAction.new(message)
        end
      end
    end

    def available?(controller_path, action_name = nil, params = {})
      StrongActions.config.roles.each do |role|
        return false unless judge(role, controller_path, action_name, params)
      end

      true
    end

    def judge(role, controller_path, action_name = nil, params = {})
      controller_path = normalize_controller_path(controller_path)

      @decision ||= StrongActions::Decision.new(self)
      @decision.call(role, controller_path, action_name, params)
    end

    def normalize_controller_path(controller_path)
      controller_path.start_with?('/') ? controller_path[1..-1] : controller_path 
    end
  end
end