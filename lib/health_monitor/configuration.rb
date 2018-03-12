module HealthMonitor
  class Configuration
    PROVIDERS = %i[cache database redis resque sidekiq].freeze

    DEFAULT_APP_NAME = "SiliconJungles"

    attr_accessor :error_callback, :basic_auth_credentials, :environment_variables, :app_name
    attr_reader :providers

    def initialize
      database
      @app_name = DEFAULT_APP_NAME
    end

    def no_database
      @providers.delete(HealthMonitor::Providers::Database)
    end

    PROVIDERS.each do |provider_name|
      define_method provider_name do |&_block|
        require "health_monitor/providers/#{provider_name}"

        add_provider("HealthMonitor::Providers::#{provider_name.capitalize}".constantize)
      end
    end

    def add_custom_provider(custom_provider_class)
      unless custom_provider_class < HealthMonitor::Providers::Base
        raise ArgumentError.new 'custom provider class must implement '\
          'HealthMonitor::Providers::Base'
      end

      add_provider(custom_provider_class)
    end

    private

    def add_provider(provider_class)
      (@providers ||= Set.new) << provider_class

      provider_class
    end
  end
end
