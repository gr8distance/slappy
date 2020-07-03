module Slappy
  module SlackAPI
    class Conversation < Base
      self.monitor_event = %w(create close rename archive unarchive)

      def name
        '#' + @data.name
      end
    end
  end
end
