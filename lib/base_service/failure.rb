module BaseService
  class Failure < RuntimeError
    def initialize(service, result)
      @result = result
      super "#{service.class} failed"
    end

    attr_reader :result
  end
end
