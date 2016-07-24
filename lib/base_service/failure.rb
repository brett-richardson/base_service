module BaseService
  class Failure < RuntimeError
    def initialize(service_class, result)
      @result = result
      super "#{service_class} failed"
    end

    attr_reader :result
  end
end
