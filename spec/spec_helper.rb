# frozen_string_literal: true

# load the client gem for testing
require 'resource_allocator'

Dir[File.expand_path('../support/**/*.rb', __dir__)].each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
