module Slack
  class Notifier
    class PayloadMiddleware
      class At < Base

        SPECIAL_COMMANDS = [:here, :channel, :everyone, :group]

        middleware_name :at

        options at: []

        def call payload={}
          return payload unless payload[:text]
          payload[:text] = add_ats(payload[:text], payload.delete(:at))
          payload
        end

        private

        def add_ats(message, ats)
          ats = Array(ats)
          ats.reverse.reduce(message) do |message, at|
            command_chr = SPECIAL_COMMANDS.include?(at) ? '!' : '@'
            "<#{command_chr}#{at}> #{message}"
          end
        end
      end
    end
  end
end
