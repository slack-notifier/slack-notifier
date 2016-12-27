# frozen_string_literal: true
module Slack
  class Notifier
    class PayloadMiddleware
      class FormatAttachments < Base
        middleware_name :format_attachments

        def call payload={}
          attachments = payload.fetch(:attachments, payload["attachments"])
          wrap_array(attachments).each do |attachment|
            ["text", :text].each do |key|
              attachment[key] = Util::LinkFormatter.format(attachment[key]) if attachment.key?(key)
            end
          end

          payload
        end

        private

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
