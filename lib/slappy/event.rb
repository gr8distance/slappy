module Slappy
  class Event
    extend Forwardable
    include Debuggable

    attr_accessor :matches, :data

    def_delegators :@data, :method_missing, :respond_to_missing?

    def initialize(data)
      @data = Hashie::Mash.new data
    end

    def text
      @data['text'].to_s
    end

    def channel
      SlackAPI::Conversation.find(id: @data['channel']) ||
        SlackAPI::Direct.find(id: @data['channel'])
    end

    def user
      SlackAPI::User.find(id: @data['user'])
    end

    def ts
      Time.at((@data['ts'] || @data['event_ts']).to_f)
    end

    def reply(text, options = {})
      options[:text] = text
      options[:channel] = channel
      Messenger.new(options).message
    end

    def reaction(emoji)
      result = ::Slack.reactions_add name: emoji, channel: @data['channel'], timestamp: @data['ts']
      Debug.log "Reaction response: #{result}"
    end

    def bot_message?
      @data['subtype'] && @data['subtype'] == 'bot_message'
    end
  end
end
