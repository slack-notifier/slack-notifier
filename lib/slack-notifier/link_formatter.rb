module Slack
  class Notifier
    class LinkFormatter

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

      # rubocop:disable Style/MultilineBlockChain
      def formatted
        @orig.gsub(html_pattern) do
          slack_link Regexp.last_match[1], Regexp.last_match[2]
        end.gsub(markdown_pattern) do
          slack_link Regexp.last_match[2], Regexp.last_match[1]
        end
      rescue => e
        if RUBY_VERSION < '2.1' && e.message.include?('invalid byte sequence')
          raise e, "#{e.message}. Consider including the 'string-scrub' gem to strip invalid characters"
        else
          raise e
        end
      end
      # rubocop:enable Style/MultilineBlockChain

      private

        def slack_link link, text=nil
          out = "<#{link}"
          out << "|#{text}" if text && !text.empty?
          out << '>'

          out
        end

        # http://rubular.com/r/19cNXW5qbH
        def html_pattern
          / <a (?:.*?) href=['"](.+?)['"] (?:.*?)> (.+?) <\/a> /x
        end

        # http://rubular.com/r/guJbTK6x1f
        def markdown_pattern
          /\[ ([^\[\]]*?) \] \( ((https?:\/\/.*?) | (mailto:.*?)) \) /x
        end

    end
  end
end
