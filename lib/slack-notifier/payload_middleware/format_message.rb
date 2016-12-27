# frozen_string_literal: true
module Slack
  class Notifier
    class PayloadMiddleware
      class FormatMessage < Base
        middleware_name :format_message

        def call payload={}
          payload[:text] = Util::LinkFormatter.format(payload[:text]) if payload[:text]

          payload
        end
      end
    end
  end
end
