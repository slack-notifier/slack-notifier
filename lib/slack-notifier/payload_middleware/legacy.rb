module Slack
  class Notifier
    class PayloadMiddleware
      class Legacy < Base
        middleware_name :legacy

        def call payload={}
          attachments = payload.fetch(:attachments, payload['attachments'])
          wrap_array(attachments).each do |attachment|
            ['text', :text].each do |key|
              attachment[key] = LinkFormatter.format(attachment[key]) if attachment.key?(key)
            end
          end

          payload[:text] = LinkFormatter.format(payload[:text]) if payload[:text]

          payload
        end

        def wrap_array object
          if object.nil?
            []
          elsif object.respond_to?(:to_ary)
            object.to_ary || [object]
          else
            [object]
          end
        end
      end
    end
  end
end
