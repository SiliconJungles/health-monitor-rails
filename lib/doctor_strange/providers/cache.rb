require 'doctor_strange/providers/base'

module DoctorStrange
  module Providers
    class CacheException < StandardError; end

    class Cache < Base
      def check!
        time = Time.now.to_s

        Rails.cache.write(key, time)
        fetched = Rails.cache.read(key)

        raise "different values (now: #{time}, fetched: #{fetched})" if fetched != time
      rescue StandardError => e
        raise CacheException, e.message
      end

      private

        def key
          @key ||= ['health', request.try(:remote_ip)].join(':')
        end
    end
  end
end
