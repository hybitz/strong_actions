require 'action_controller'
require "strong_actions/version"
require "strong_actions/config"
require "strong_actions/forbidden_action"
require 'strong_actions/controller_extensions'

module StrongActions

  def self.config
    StrongActions::Config.instance
  end

  def self.config_files
    config.config_files
  end

  def self.config_files=(files)
    config.config_files = files
  end

end

require 'strong_actions/railtie' if defined?(Rails)
