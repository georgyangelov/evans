if Rails.env.test?
  Rails.application.config.slack_bot_enabled = false
else
  Rails.application.config.slack_bot_enabled = !Rails.application.config.slack_bot_token.blank?

  Slack.configure do |config|
    config.token = Rails.application.config.slack_bot_token
  end
end
