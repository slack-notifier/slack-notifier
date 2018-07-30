# frozen_string_literal: true

module Slack
  class Notifier
    class PayloadMiddleware
      class FormatMessage < Base
        middleware_name :format_message

        options formats: %i[html markdown]

        def call payload={}
          return payload.to_s unless payload[:text]
          payload[:text] = Util::LinkFormatter.format(payload[:text], options)

          payload.to_s
        end
      end
    end
  end
end
