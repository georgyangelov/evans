require 'spec_helper'

describe RevisionObserver do
  context 'with disabled Slack integration' do
    around do |example|
      Rails.application.config.slack_bot_enabled = false
      example.run
      Rails.application.config.slack_bot_enabled = true
    end

    it 'does not call the notification worker' do
      expect(SlackSolutionNotificationWorker).to_not receive(:perform_async)

      create :comment
    end
  end

  context 'with enabled Slack integration' do
    it "posts a message on Slack" do
      expect(SlackSolutionNotificationWorker).to receive(:perform_async).with(42)

      create :solution_with_revisions, id: 42
    end
  end
end
