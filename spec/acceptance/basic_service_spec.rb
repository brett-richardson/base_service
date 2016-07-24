require 'spec_helper'
require 'base_service'

module AcceptanceHelpers
  def step(message)
    puts message
  end
end

RSpec.describe "Creating a basic service object" do
  include AcceptanceHelpers

  # Setup

  class MyService
    include BaseService

    def initialize(param1, param2)
      @param1, @param2 = param1, param2
    end

    private
    attr_reader :param1, :param2

    def perform
      return failure "no param1", :param1_error  unless param1.present?
      return failure "no param2", :param2_error  unless param2.present?
      return failure "neither param1 or 2" unless param1.present? && param2.present?

      return success "success!"
    end
  end

  # Specs

  specify "Using the service return values" do
    step "I initialize my service correctly"
    instance = MyService.new(1, 2)

    step "I can call the #call method on it and I get the success result"
    result = instance.call
    expect(result).to eq "success!"

    step "I initialize my service so that it raises an error"
    instance = MyService.new(1, nil)

    step "I can call the #call method and I get the failure result"
    result = instance.call
    expect(result).to eq "no param2"
  end

  specify "Using the service with a simple block" do
    step "I initialize my service correctly"
    instance = MyService.new(1, 2)

    step "I can call the #call method with a block..."
    step "...and the success case evaluates it with the result"
    side_effect = double
    expect(side_effect).to receive(:update!).with "success!"
    instance.call { |on| side_effect.update! on.result }

    step "When my service is set up to fail"
    instance = MyService.new(1, nil)

    step "the failure raises an exception, which can be caught from the block"
    expect { instance.call { |on| on.result } }.to raise_error MyService::Failure
  end

  specify "Using the service with complex result matchers" do
    step "I initialize my service correctly"
    instance = MyService.new(1, 2)

    step "The block passed to the success matcher is called"
    side_effect = double
    expect(side_effect).to receive(:update!).with "success!"

    instance.call do |on|
      on.success { |result| side_effect.update! result }
    end

    step "The blocks passed to any failure matchers are not called"
    expect(side_effect).to_not receive :destroy
    instance.call do |on|
      on.failure { |result| side_effect.destroy result }
      on.failure(:abc) { |result| side_effect.destroy result }
    end

    step "I initialize my service set to fail with code :param2_error"
    instance = MyService.new(1, nil)

    step "The block passed to the success block is not called..."
    side_effect = double
    expect(side_effect).to_not receive :update!

    step "...but the failure block is called"
    expect(side_effect).to receive(:destroy).with "no param2"

    instance.call do |on|
      on.success { |result| side_effect.update! result }
      on.failure { |error| side_effect.destroy error }
    end
  end
end
