require 'singleton'

module StrongActions
  class Config
    include Singleton

    attr_accessor :config_files
    
    def initialize
      config_files = ['config/acl.yml']
      load_config_files
    end

    def config_files=(files)
      config_files = files
      load_config_files
    end

    def roles
      load_config_files if Rails.env.development?
      @acl.keys
    end

    def role_definition(role)
      load_config_files if Rails.env.development?
      @acl[role]
    end

    private

    def load_config_files
      @acl = {}
      config_files.each do |config_file|
        yml = YAML.load_file(config_file)
        yml.each do |role, values|
          raise "role #{role} is already defined." if @acl.has_key?(role)
          @acl[role] = values
        end
      end
    end

  end
end