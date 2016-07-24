module BaseService
  class Matcher
    def initialize(service)
      @service, @success_handled, @failure_handled = service, false, false
    end

    def success
      yield result if was_success?
    end

    def failure(code = nil)
      self.failure_handled = true
      yield result unless was_success?
    end

    attr_reader :service
    attr_accessor :success_handled, :failure_handled
    alias failure_handled? failure_handled
    delegate :result, :was_success?, to: :service
  end
end

