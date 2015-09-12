require 'spec_helper'

describe SlackSolutionNotificationWorker do
  let(:user) { create :user, name: 'John Doe' }
  let(:task) { create :task, name: 'Task 1'   }

  context 'with a new solution with single revision' do
    it 'posts the correct message on Slack' do
      solution = create :solution, task: task, user: user
      create :revision, solution: solution

      solution_url = "http://trane.example.org/tasks/#{task.id}/solutions/#{solution.id}"

      expect(SlackBotService).to receive(:post_message).with(
        "*John Doe* предаде <#{solution_url}|решение> на 'Task 1'"
      )

      SlackSolutionNotificationWorker.new.perform(solution.id)
    end
  end

  context "with comment on a user's own solution" do
    it 'posts the correct message on Slack' do
      solution = create :solution, task: task, user: user
      create_list :revision, 2, solution: solution

      solution_url = "http://trane.example.org/tasks/#{task.id}/solutions/#{solution.id}"

      expect(SlackBotService).to receive(:post_message).with(
        "*John Doe* обнови <#{solution_url}|решението си> на 'Task 1'"
      )

      SlackSolutionNotificationWorker.new.perform(solution.id)
    end
  end
end
