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

      def formatted
        @orig.gsub( html_pattern ) do |match|
          link = Regexp.last_match[1]
          text = Regexp.last_match[2]
          slack_link link, text
        end.gsub( markdown_pattern ) do |match|
          link = Regexp.last_match[2]
          text = Regexp.last_match[1]
          slack_link link, text
        end

      rescue => e
        if RUBY_VERSION < '2.1' && e.message.include?('invalid byte sequence')
          raise e, "#{e.message}. Consider including the 'string-scrub' gem to strip invalid characters"
        else
          raise e
        end
      end

      private

        def slack_link link, text=nil
          out = "<#{link}"
          out << "|#{text}" if text && !text.empty?
          out << ">"

          return out
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
