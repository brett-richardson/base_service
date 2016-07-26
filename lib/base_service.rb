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
      matcher.resolve
    end

    result
  end

  attr_reader :result, :was_success, :failure_code
  alias was_success? was_success

  private

  attr_writer :was_success, :result, :failure_code
  attr_accessor :matcher

  def success(result)
    self.was_success = true
    self.result = result
  end

  def failure(result, code = nil)
    self.was_success = false
    self.result = result
    self.failure_code = code
  end
end

require 'base_service/version'
