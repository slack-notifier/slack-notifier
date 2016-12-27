# frozen_string_literal: true
module Slack
  class Notifier
    class PayloadMiddleware
      class FormatAttachments < Base
        middleware_name :format_attachments

        options formats: [:html, :markdown]

        def call payload={}
          attachments = payload.fetch(:attachments, payload["attachments"])
          wrap_array(attachments).each do |attachment|
            ["text", :text].each do |key|
              if attachment.key?(key)
                attachment[key] = Util::LinkFormatter.format(attachment[key], options)
              end
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
