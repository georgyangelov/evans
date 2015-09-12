require 'spec_helper'

describe SlackCommentNotificationWorker do
  let(:user) { create :user, name: 'John Doe' }
  let(:task) { create :task, name: 'Task 1'   }

  context "with comment on another person's solution" do
    it 'posts the correct message on Slack' do
      another_user = create :user, name: 'Santa Claus'
      solution     = create :solution_with_revisions, task: task, user: another_user
      comment      = create :comment, user: user, revision: solution.last_revision

      comment_url = "http://trane.example.org/tasks/#{task.id}/solutions/#{solution.id}#comment-#{comment.id}"

      expect(SlackBotService).to receive(:post_message).with(
        "*John Doe* <#{comment_url}|коменира> решението на *Santa Claus* на 'Task 1'"
      )

      SlackCommentNotificationWorker.new.perform(comment.id)
    end
  end

  context "with comment on a user's own solution" do
    it 'posts the correct message on Slack' do
      solution = create :solution_with_revisions, task: task, user: user
      comment  = create :comment, user: user, revision: solution.last_revision

      comment_url = "http://trane.example.org/tasks/#{task.id}/solutions/#{solution.id}#comment-#{comment.id}"

      expect(SlackBotService).to receive(:post_message).with(
        "*John Doe* <#{comment_url}|коменира> решението си на 'Task 1'"
      )

      SlackCommentNotificationWorker.new.perform(comment.id)
    end
  end
end
