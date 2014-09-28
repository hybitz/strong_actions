require 'singleton'

module StrongActions
  class Config
    include Singleton

    def initialize
      @config_files ||= ['config/acl.yml']
    end

    def config_files
      @config_files
    end

    def config_files=(files)
      @config_files = ([] << files).flatten
    end

    def roles
      definitions.keys
    end

    def role_definition(role)
      definitions[role]
    end

    private

    def definitions
      if @acl.nil? or Rails.env.development?
        @acl = {}
        config_files.each do |config_file|
          yml = YAML.load_file(config_file)
          yml.each do |role, values|
            raise "role #{role} is already defined." if @acl.has_key?(role)
            @acl[role] = values
          end
        end
      end
      @acl
    end

  end
end