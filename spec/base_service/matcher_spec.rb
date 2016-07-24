require 'spec_helper'
require 'base_service/matcher'

RSpec.describe BaseService::Matcher do
  subject(:instance) { described_class.new service }
  let(:service) { double result: result, was_success?: was_success? }
  let(:was_success?) { true }
  let(:result) { "yay!" }

  describe "#success" do
    context "when the service was successful" do
      it "yields the result" do
        expect { |b| subject.success &b }.to yield_with_args result
      end
    end

    context "when the service was not successful" do
      let(:was_success?) { false }

      it "does not yield" do
        expect { |b| subject.success &b }.to_not yield_control
      end
    end
  end

  describe "#failure" do
    context "when the service was successful" do
      it "does not yield" do
        expect { |b| subject.failure &b }.to_not yield_control
      end
    end

    context "when the service was not successful" do
      let(:was_success?) { false }

      it "does yields the result" do
        expect { |b| subject.failure &b }.to yield_with_args result
      end
    end
  end

  describe "#failure_handled?" do
    it "is false until the failure method is called" do
      expect(instance.failure_handled?).to eq false
      instance.failure
      expect(instance.failure_handled?).to eq true
    end
  end
end
