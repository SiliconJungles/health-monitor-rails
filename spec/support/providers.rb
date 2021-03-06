require 'spec_helper'

module Providers
  include RSpec::Mocks::ExampleMethods

  extend self

  def stub_cache_failure
    allow(Rails.cache).to receive(:read).and_return(false)
  end

  def stub_database_failure
    allow(ActiveRecord::Base).to receive(:connected?).and_return(false)
  end

  def stub_redis_failure
    allow_any_instance_of(Redis).to receive(:get).and_return(false)
  end

  def stub_redis_max_user_memory_failure
    allow_any_instance_of(Redis).to receive(:info).and_return('used_memory' => '1000000000')
  end

  def stub_resque_failure
    allow(Resque).to receive(:info).and_raise(Exception)
  end

  def stub_sidekiq
    allow_any_instance_of(Sidekiq::Stats).to receive(:processes_size).and_return(10)
  end

  def stub_sidekiq_workers_failure
    allow_any_instance_of(Sidekiq::Workers).to receive(:size).and_raise(Exception)
  end

  def stub_sidekiq_no_processes_failure
    allow_any_instance_of(Sidekiq::Stats).to receive(:processes_size).and_return(0)
  end

  def stub_sidekiq_latency_failure
    allow_any_instance_of(Sidekiq::Queue).to receive(:latency).and_return(Float::INFINITY)
  end

  def stub_sidekiq_queue_size_failure
    allow_any_instance_of(Sidekiq::Queue).to receive(:size).and_return(Float::INFINITY)
  end

  def stub_sidekiq_redis_failure
    allow(Sidekiq).to receive(:redis).and_raise(Redis::CannotConnectError)
  end

  def stub_mailgun_failure
    allow_any_instance_of(Mailgun::Domains).to receive(:list).and_raise(Mailgun::CommunicationError)
  end

  def stub_mailgun
    allow_any_instance_of(Mailgun::Domains).to receive(:list).and_return(["foo.bar"])
  end

  def stub_stripe_failure
    allow(Stripe::Customer).to receive(:list).and_raise(Stripe::AuthenticationError)
  end

  def stub_stripe
    allow(Stripe::Customer).to receive(:list).and_return(true)
  end
end
