module Slack
  class Notifier

    class PayloadMiddleware

      class << self

        def registry
          @registry ||= {}
        end

        def register middleware, name
          registry[name] = middleware
        end

      end

    end

  end
end

require_relative 'payload_middleware/stack'
require_relative 'payload_middleware/base'
