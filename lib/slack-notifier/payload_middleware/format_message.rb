# frozen_string_literal: true
module Slack
  class Notifier
    class PayloadMiddleware
      class FormatMessage < Base
        middleware_name :format_message

        def call payload={}
          return payload unless payload[:text]
          payload[:text] = Util::LinkFormatter.format(*[payload[:text], options[:formats]].compact)

          payload
        end
      end
    end
  end
end
