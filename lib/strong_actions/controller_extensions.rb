require 'strong_actions/decision'

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
      StrongActions.config.roles.each do |role|
        return false unless judge(role, controller_name, action_name, params)
      end

      true
    end

    def judge(role, controller_name, action_name = nil, params = {})
      @decision ||= StrongActions::Decision.new(self)
      @decision.call(role, controller_name, action_name, params)
    end

  end
end