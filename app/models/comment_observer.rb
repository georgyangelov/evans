class CommentObserver < ActiveRecord::Observer
  def after_create(comment)
    notify_solution_author(comment)
    notify_team(comment)
  end

  private

  def notify_solution_author(comment)
    return if comment.user == comment.solution.user
    return unless comment.solution.user.comment_notification?

    SolutionMailer.new_comment(comment).deliver
  end

  def notify_team(comment)
    return unless Rails.application.config.slack_bot_enabled

    SlackCommentNotificationWorker.perform_async(comment.id)
  end
end
