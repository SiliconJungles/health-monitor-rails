require 'spec_helper'

describe DoctorStrange::Configuration do
  let(:default_configuration) { Set.new([DoctorStrange::Providers::Database]) }

  describe 'defaults' do
    it { expect(subject.providers).to eq(default_configuration) }
    it { expect(subject.error_callback).to be_nil }
    it { expect(subject.basic_auth_credentials).to be_nil }
    it { expect(subject.app_name).to eq("SiliconJungles") }
  end

  describe 'providers' do
    DoctorStrange::Configuration::PROVIDERS.each do |provider_name|
      before do
        subject.instance_variable_set('@providers', Set.new)

        stub_const("DoctorStrange::Providers::#{provider_name.capitalize}", Class.new)
      end

      it "responds to #{provider_name}" do
        expect(subject).to respond_to(provider_name)
      end

      it "configures #{provider_name}" do
        expect {
          subject.send(provider_name)
        }.to change { subject.providers }.to(Set.new(["DoctorStrange::Providers::#{provider_name.capitalize}".constantize]))
      end

      it "returns #{provider_name}'s class" do
        expect(subject.send(provider_name)).to eq("DoctorStrange::Providers::#{provider_name.capitalize}".constantize)
      end
    end
  end

  describe '#add_custom_provider' do
    before do
      subject.instance_variable_set('@providers', Set.new)
    end

    context 'inherits' do
      class CustomProvider < DoctorStrange::Providers::Base
      end

      it 'accepts' do
        expect {
          subject.add_custom_provider(CustomProvider)
        }.to change { subject.providers }.to(Set.new([CustomProvider]))
      end

      it 'returns CustomProvider class' do
        expect(subject.add_custom_provider(CustomProvider)).to eq(CustomProvider)
      end
    end

    context 'does not inherit' do
      class TestClass
      end

      it 'does not accept' do
        expect {
          subject.add_custom_provider(TestClass)
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#no_database' do
    it 'removes the default database check' do
      expect {
        subject.no_database
      }.to change { subject.providers }.from(default_configuration).to(Set.new)
    end
  end
end
