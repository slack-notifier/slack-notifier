module Slack
  class Notifier
    class LinkFormatter

      class << self

        def format string
          LinkFormatter.new(string).formatted
        end

      end

      def initialize string
        @orig = string
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
      end

      private

        def slack_link link, text=nil
          out = "<#{link}"
          out << "|#{text}" if text && !text.empty?
          out << ">"

          return out
        end

        def html_pattern
          / <a (?:.*?) href=['"](.+?)['"] (?:.*?)> (.+?) <\/a> /x
        end

        def markdown_pattern
          /\[(.*?)\]\((.+?)\)/
        end

    end
  end
end