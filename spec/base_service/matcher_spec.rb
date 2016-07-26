require 'spec_helper'
require 'base_service/matcher'

RSpec.describe BaseService::Matcher do
  subject(:instance) { described_class.new service }
  let(:service) { double result: result, was_success?: was_success?, failure_code: failure_code }
  let(:was_success?) { true }
  let(:result) { "yay!" }
  let(:failure_code) { nil }

  describe "#resolve" do
    it("runs") { instance.resolve }
  end

  describe "#success" do
    context "when the service was successful" do
      it "yields the result" do
        expect do |b|
          subject.success &b
          subject.resolve
        end.to yield_with_args result
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
        expect do |b|
          subject.failure &b
          subject.resolve
        end.to yield_with_args result
      end

      context "when called with a failure code" do
        context "the code matches" do
          let(:side_effect) { double }
          let(:failure_code) { :specific_failure_code }

          it "yields to the failure block with the code, and no others" do
            expect(side_effect).to receive :call

            subject.failure { raise 'hell' }
            subject.success { raise 'more hell' }
            subject.failure(failure_code) { side_effect.call }
            subject.resolve
          end
        end
      end
    end
  end
end
