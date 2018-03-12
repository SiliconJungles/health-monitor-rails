# require 'health_monitor/providers/base'
#
# module HealthMonitor
#   module Providers
#     class AppInfoException < StandardError; end
#
#     class AppInfo < Base
#       class Configuration
#         attr_accessor :app_name
#       end
#
#       class << self
#         private
#
#         def configuration_class
#           ::HealthMonitor::Providers::AppInfo::Configuration
#         end
#       end
#
#       def check!
#         return unless configuration.app_name.nil?
#
#         raise RedisException.new(e.message)
#       end
#     end
#   end
# end
