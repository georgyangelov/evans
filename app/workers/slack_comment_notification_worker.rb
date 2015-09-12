class SlackCommentNotificationWorker
  include Sidekiq::Worker

  include Rails.application.routes.url_helpers
  include CustomPaths

  def perform(comment_id)
    comment = Comment.find(comment_id)

    SlackBotService.post_message comment_message(comment)
  end

  private

  def comment_message(comment)
    message_type = if comment.user == comment.solution.user
                     'slack_bot.tasks.comments.own_task_solution'
                   else
                     'slack_bot.tasks.comments.task_solution'
                   end

    I18n.t message_type, comment_author_name: comment.user_name,
                         solution_author_name: comment.solution.user_name,
                         task_name: comment.task_name,
                         url: comment_url(comment)
  end
end
