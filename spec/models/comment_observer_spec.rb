require 'spec_helper'

describe CommentObserver do
  it "notifies the solution author via email" do
    comment = build :comment
    expect_email_delivery SolutionMailer, :new_comment, comment
    comment.save!
  end

  it "does not notify people about comments they make on their own solutions" do
    revision = create :revision
    comment  = build :comment, revision: revision, user: revision.solution.user

    SolutionMailer.should_not_receive(:new_comment)

    comment.save!
  end

  it "does not notify people, who have disabled email notification" do
    user     = create :user, comment_notification: false
    solution = create :solution_with_revisions, user: user
    comment  = build :comment, revision: solution.revisions.first

    SolutionMailer.should_not_receive(:new_comment)

    comment.save!
  end

  context 'with disabled Slack integration' do
    around do |example|
      Rails.application.config.slack_bot_enabled = false
      example.run
      Rails.application.config.slack_bot_enabled = true
    end

    it 'does not call the notification worker' do
      expect(SlackCommentNotificationWorker).to_not receive(:perform_async)

      create :comment
    end
  end

  context 'with enabled Slack integration' do
    it "posts a message on Slack" do
      expect(SlackCommentNotificationWorker).to receive(:perform_async).with(42)

      create :comment, id: 42
    end
  end
end
