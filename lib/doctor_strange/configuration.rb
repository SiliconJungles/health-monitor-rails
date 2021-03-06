module DoctorStrange
  class Configuration
    PROVIDERS = %i[cache database redis resque sidekiq email payment].freeze

    DEFAULT_APP_NAME = "SiliconJungles".freeze

    attr_accessor :error_callback, :basic_auth_credentials, :environment_variables, :app_name
    attr_reader :providers

    def initialize
      database
      @app_name = DEFAULT_APP_NAME
    end

    def no_database
      @providers.delete(DoctorStrange::Providers::Database)
    end

    PROVIDERS.each do |provider_name|
      define_method provider_name do |&_block|
        require "doctor_strange/providers/#{provider_name}"

        add_provider("DoctorStrange::Providers::#{provider_name.capitalize}".constantize)
      end
    end

    def add_custom_provider(custom_provider_class)
      unless custom_provider_class < DoctorStrange::Providers::Base
        raise ArgumentError, 'custom provider class must implement '\
          'DoctorStrange::Providers::Base'
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
