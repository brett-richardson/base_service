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
end
