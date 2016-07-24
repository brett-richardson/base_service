BaseService
===========

The client should extend this module, in order to implement this common
service object pattern.

```ruby

MyService.new(param1, param2).call do |on|
  on.success { |result| puts "Success #{result}" }

  on.failure { |error| puts "Generic failure #{error}" }
  on.failure(:param1_error) { |error| puts "Problem with param1 #{param1}" }
  on.failure(:param2_error) { |error| puts "Problem with param1 #{param1}" }
end

```

## Support for legacy behaviour

```ruby

result = MyService.new(param1, param2).call

```

## Example Service

```ruby

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

    return "success!"
  end
end

```

