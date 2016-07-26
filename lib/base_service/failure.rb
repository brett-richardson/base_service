module BaseService
  class Failure < RuntimeError
    def initialize(service, result, code = nil)
      @result, @code = result, code
      super "#{service.class} failed"
    end

    attr_reader :result
  end
end
