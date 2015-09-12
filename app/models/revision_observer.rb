class RevisionObserver < ActiveRecord::Observer
  def after_create(revision)
    return unless Rails.application.config.slack_bot_enabled

    SlackSolutionNotificationWorker.perform_async(revision.solution.id)
  end
end
