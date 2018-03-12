require 'spec_helper'

describe HealthMonitor::Providers::Email do
  describe HealthMonitor::Providers::Email::Configuration do
    describe 'defaults' do
      it { expect(described_class.new.service_name).to eq(HealthMonitor::Providers::Email::Configuration::DEFAULT_SERVICE_NAME) }
    end
  end

  subject { described_class.new(request: test_request) }

  describe '#provider_name' do
    it { expect(described_class.provider_name).to eq('Email') }
  end

  describe "#check!" do
    context "success" do
      before do
        Providers.stub_mailgun
        described_class.configure do |config|
          config.api_key = "abcd"
          config.domain = "foo.bar"
        end
      end
      it 'succesfully checks' do
        expect {
          subject.check!
        }.not_to raise_error
      end
    end

    context "failing" do
      before do
        Providers.stub_mailgun_failure
        described_class.configure do |config|
          config.api_key = "abcd"
          config.domain = "foo.bar"
        end
      end

      it 'fails check!' do
        expect {
          subject.check!
        }.to raise_error(HealthMonitor::Providers::EmailException, 'Cannot communicate to Mailgun')
      end
    end
  end

  describe '#configurable?' do
    it { expect(described_class).to be_configurable }
  end

  describe '#configure' do
    before do
      described_class.configure
    end

    let(:api_key) { SecureRandom.hex }
    let(:domain) { "foo.bar" }

    it 'api_key could be configured' do
      expect {
        described_class.configure do |config|
          config.api_key = api_key
        end
      }.to change { described_class.new.configuration.api_key }.to(api_key)
    end

    it 'domain could be configured' do
      expect {
        described_class.configure do |config|
          config.domain = domain
        end
      }.to change { described_class.new.configuration.domain }.to(domain)
    end

    it 'fails check!' do
      described_class.configure do |config|
        config.api_key = ""
        config.domain = ""
      end
      expect {
        subject.check!
      }.to raise_error(HealthMonitor::Providers::EmailException, 'The api_key and domain are required')
    end
  end
end
