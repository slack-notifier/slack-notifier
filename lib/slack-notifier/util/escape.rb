# frozen_string_literal: true

module Slack
  class Notifier
    module Util
      module Escape
        def self.html string
          string.encode(xml: :text)
        end
      end
    end
  end
end
