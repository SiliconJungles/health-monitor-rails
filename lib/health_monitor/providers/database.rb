require 'health_monitor/providers/base'

module HealthMonitor
  module Providers
    class DatabaseException < StandardError; end

    class Database < Base
      def check!
        # Check connection to the DB:
        ActiveRecord::Base.establish_connection # Establishes connection
        ActiveRecord::Base.connection # Calls connection object
        raise DatabaseException.new("Your database is not connected") unless ActiveRecord::Base.connected?
      end
    end
  end
end
