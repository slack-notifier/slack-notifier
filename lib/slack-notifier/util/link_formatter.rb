# frozen_string_literal: true
module Slack
  class Notifier
    module Util
      class LinkFormatter
        # http://rubular.com/r/19cNXW5qbH
        HTML_PATTERN = / <a (?:.*?) href=['"](.+?)['"] (?:.*?)> (.+?) <\/a> /x

        # http://rubular.com/r/guJbTK6x1f
        MARKDOWN_PATTERN = /\[ ([^\[\]]*?) \] \( ((https?:\/\/.*?) | (mailto:.*?)) \) /x

        class << self

          def format string
            LinkFormatter.new(string).formatted
          end

        end

        def initialize string
          @orig = if string.respond_to? :scrub
            string.scrub
          else
            string
          end
        end

        # rubocop:disable Style/MultilineBlockChain, Style/GuardClause
        def formatted
          @orig.gsub(HTML_PATTERN) do
            slack_link Regexp.last_match[1], Regexp.last_match[2]
          end.gsub(MARKDOWN_PATTERN) do
            slack_link Regexp.last_match[2], Regexp.last_match[1]
          end
        rescue => e
          if RUBY_VERSION < "2.1" && e.message.include?("invalid byte sequence")
            raise e, "#{e.message}. Consider including the 'string-scrub' gem to strip invalid characters"
          else
            raise e
          end
        end
        # rubocop:enable Style/MultilineBlockChain, Style/GuardClause

        private

          def slack_link link, text=nil
            "<#{link}" \
            "#{text && !text.empty? ? "|#{text}" : ''}" \
            ">"
          end
      end
    end
  end
end
