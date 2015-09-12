module SlackBotService
  extend self

  def post_message(text)
    client = Slack::Web::Client.new
    channel = slack_channel(client)

    client.chat_postMessage channel: channel['id'], text: text, as_user: true
  end

  private

  def slack_channel(client)
    client.channels_list['channels'].find do |channel|
      channel['name'] == Rails.application.config.slack_bot_channel
    end
  end
end
