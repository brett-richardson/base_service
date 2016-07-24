require 'active_support'
require 'active_support/core_ext/object'

module BaseService
  def call
    perform
    result
  end

  private
  attr_accessor :success, :result

  def success(result)
    self.success = true
    self.result = result
  end

  def failure(result, code = nil)
    self.success = false
    self.result = result
  end
end

require 'base_service/version'
