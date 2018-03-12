require 'doctor_strange/providers/base'
require 'mailgun'

module DoctorStrange
  module Providers
    class EmailException < StandardError; end

    class Email < Base
      class Configuration
        DEFAULT_SERVICE_NAME = "MailGun"

        attr_accessor :api_key, :domain, :service_name

        def initialize
          @service_name = DEFAULT_SERVICE_NAME
        end
      end

      class << self
        private

        def configuration_class
          ::DoctorStrange::Providers::Email::Configuration
        end
      end

      def check!
        check_required_values!
        check_communication!
      rescue Exception => e
        raise EmailException.new(e.message)
      end

      private

      def check_required_values!
        raise "The api_key and domain are required" if configuration.api_key.empty? || configuration.domain.empty?
      end

      def check_communication!
        mg_client = ::Mailgun::Client.new(configuration.api_key)
        result = mg_client.get("#{configuration.domain}/events", {:event => 'delivered'})
      rescue ::Mailgun::CommunicationError => e
        raise "Cannot communicate to Mailgun"
      end
    end
  end
end
