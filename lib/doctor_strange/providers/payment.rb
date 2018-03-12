require 'doctor_strange/providers/base'
require 'stripe'

module DoctorStrange
  module Providers
    class PaymentException < StandardError; end

    class Payment < Base
      class Configuration
        DEFAULT_SERVICE_NAME = "Stripe".freeze

        attr_accessor :api_key, :service_name

        def initialize
          @service_name = DEFAULT_SERVICE_NAME
        end
      end

      class << self
        private

        def configuration_class
          ::DoctorStrange::Providers::Payment::Configuration
        end
      end

      def check!
        check_required_values!
        check_communication!
      rescue Exception => e
        raise PaymentException.new(e.message)
      end

      private

        def check_required_values!
          raise "The api_key is required" if configuration.api_key.empty?
        end

        def check_communication!
          Stripe.api_key = configuration.api_key
          Stripe::Customer.list(limit: 1)
        rescue Stripe::AuthenticationError
          raise "Invalid API Key provided"
        end
    end
  end
end
