require 'singleton'
require 'yaml'

module StrongActions
  class Config
    include Singleton

    def initialize
      @config_files ||= ['config/acl.yml']
      @mutex  = Mutex.new
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
      if should_load?
        with_mutex do
          if should_load?
            @acl = {}
            config_files.each do |config_file|
              yml = YAML.load_file(config_file)
              yml.each do |role, values|
                raise "role #{role} is defined multiple times. config files are [#{config_files.join(', ')}]" if @acl.has_key?(role)
                @acl[role] = values
              end
            end
          end
        end
      end
      @acl
    end

    def should_load?
      @acl.nil? or Rails.env.development?
    end
      
    def with_mutex
      @mutex.synchronize do
        yield
      end
    end

  end
end