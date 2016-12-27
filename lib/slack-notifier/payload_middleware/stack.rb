# frozen_string_literal: true
module Slack
  class Notifier
    class PayloadMiddleware
      class Stack
        attr_reader :notifier,
                    :stack

        def initialize notifier
          @notifier = notifier
          @stack    = []
        end

        def set *middlewares
          middlewares =
            if middlewares.length == 1 && middlewares.first.is_a?(Hash)
              middlewares.first
            else
              middlewares.flatten
            end

          @stack = middlewares.map do |key, opts|
            PayloadMiddleware.registry.fetch(key).new(*[notifier, opts].compact)
          end
        end

        def call payload={}
          stack.inject payload do |pld, middleware|
            middleware.call(pld)
          end
        end
      end
    end
  end
end
