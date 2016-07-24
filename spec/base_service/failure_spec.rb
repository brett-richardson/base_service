require 'spec_helper'
require 'base_service/failure'

RSpec.describe BaseService::Failure do
  subject { described_class.new service_klass, result }
  let(:service_klass) { double }
  let(:result) { 123 }

  it { is_expected.to be_a RuntimeError }

  its(:result) { is_expected.to eq 123 }
end
