module BaseService
  class Matcher
    def initialize(service)
      @service, @specific_failure_blocks = service, {}
    end

    def success(&block)
      self.generic_success_block = block
    end

    def failure(code = nil, &block)
      if code.nil?
        self.generic_failure_block = block
      else
        specific_failure_blocks[code] = block
      end
    end

    def resolve
      return appropriate_failure_block.call result if !was_success?
      generic_success_block.call result if generic_success_block.present?
    end

    attr_reader :service, :specific_failure_blocks
    attr_accessor :generic_success_block, :generic_failure_block
    delegate :result, :was_success?, :failure_code, to: :service

    def failure_handled?
      generic_failure_block.present? || specific_failure_blocks[failure_code].present?
    end

    def appropriate_failure_block
      specific_failure_blocks[failure_code] || generic_failure_block || raise_failure_not_handled
    end

    def raise_failure_not_handled
      raise Failure.new(service, result, failure_code)
    end
  end
end

