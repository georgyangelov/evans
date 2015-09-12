class SlackSolutionNotificationWorker
  include Sidekiq::Worker

  include Rails.application.routes.url_helpers
  include CustomPaths

  def perform(solution_id)
    solution = Solution.find(solution_id)
    first_revision = solution.revisions.size == 1

    message_type = first_revision ? 'new_solution' : 'new_revision'
    message = I18n.t "slack_bot.tasks.#{message_type}", solution_author_name: solution.user_name,
                                                        task_name: solution.task_name,
                                                        url: solution_url(solution)

    SlackBotService.post_message message
  end
end
