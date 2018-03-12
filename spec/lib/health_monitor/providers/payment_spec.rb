require 'spec_helper'

describe DoctorStrange::Providers::Payment do
  describe DoctorStrange::Providers::Payment::Configuration do
    describe 'defaults' do
      it { expect(described_class.new.service_name).to eq(DoctorStrange::Providers::Payment::Configuration::DEFAULT_SERVICE_NAME) }
    end
  end

  subject { described_class.new(request: test_request) }

  describe '#provider_name' do
    it { expect(described_class.provider_name).to eq('Payment') }
  end

  describe "#check!" do
    context "success" do
      before do
        Providers.stub_stripe
        described_class.configure do |config|
          config.api_key = "abcd"
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
        Providers.stub_stripe_failure
        described_class.configure do |config|
          config.api_key = "abcd"
        end
      end

      it 'fails check!' do
        expect {
          subject.check!
        }.to raise_error(DoctorStrange::Providers::PaymentException, 'Invalid API Key provided')
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

    it 'api_key could be configured' do
      expect {
        described_class.configure do |config|
          config.api_key = api_key
        end
      }.to change { described_class.new.configuration.api_key }.to(api_key)
    end

    it 'fails check!' do
      described_class.configure do |config|
        config.api_key = ""
      end
      expect {
        subject.check!
      }.to raise_error(DoctorStrange::Providers::PaymentException, 'The api_key is required')
    end
  end
end
