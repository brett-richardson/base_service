require 'active_support'
require 'active_support/core_ext/object'
require 'base_service/matcher'
require 'base_service/failure'

module BaseService
  def call
    perform

    if block_given?
      self.matcher = Matcher.new self
      yield matcher
      raise Failure.new(self, result) unless was_success? || failure_handled?
    end

    result
  end

  attr_reader :result, :was_success
  alias was_success? was_success

  private

  attr_writer :was_success, :result
  attr_accessor :matcher
  delegate :failure_handled?, to: :matcher

  def success(result)
    self.was_success = true
    self.result = result
  end

  def failure(result, code = nil)
    self.was_success = false
    self.result = result
  end
end

require 'base_service/version'
