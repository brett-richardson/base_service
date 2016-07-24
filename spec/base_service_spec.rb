require 'spec_helper'

class DummyClass
  include BaseService

  def initialize(should_fail = false)
    @should_fail = should_fail
  end

  def perform
    return success "success result" unless @should_fail
    return failure "failure result"
  end
end

describe BaseService do
  let(:should_fail) { false }

  it { is_expected.to be_a Module }

  context "when extended from a class" do
    subject { DummyClass.new should_fail }

    describe "an instance" do
      it { is_expected.to respond_to :call }
    end

    describe "an instance that runs successfully" do
      it "returns a success result" do
        expect(subject.call).to eq "success result"
      end
    end

    describe "an instance that runs unsuccessfully" do
      let(:should_fail) { true }

      it "returns a failure result" do
        expect(subject.call).to eq "failure result"
      end
    end
  end
end
