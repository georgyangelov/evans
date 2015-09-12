require 'spec_helper'

describe SlackBotService do
  let(:slack_client) do
    double Slack::Web::Client, channels_list: {
      'channels' => [{'id' => 1, 'name' => 'channel_name'}]
    }
  end

  before do
    allow(Slack::Web::Client).to receive(:new).and_return(slack_client)

    Rails.application.config.slack_bot_channel = 'channel_name'
  end

  describe '#post_message' do
    it 'uses the Slack client to post a message' do
      expect(slack_client).to receive(:chat_postMessage).with channel: 1,
                                                              text: 'message text',
                                                              as_user: true

      SlackBotService.post_message 'message text'
    end
  end
end
