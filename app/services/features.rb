module Features
  extend self

  DEFAULT_FEATURES = [
    'dashboard',
    'news',
    'lectures',
    'forums',
    'tasks',
    'tips',
    'challenges',
    'leaderboard',
    'team'
  ].freeze

  def dashboard_enabled?
    feature_enabled? :dashboard
  end

  def news_enabled?
    feature_enabled? :news
  end

  def lectures_enabled?
    feature_enabled? :lectures
  end

  def forums_enabled?
    feature_enabled? :forums
  end

  def tasks_enabled?
    feature_enabled? :tasks
  end

  def tips_enabled?
    feature_enabled? :tips
  end

  def challenges_enabled?
    feature_enabled? :challenges
  end

  def leaderboard_enabled?
    feature_enabled? :leaderboard
  end

  def team_enabled?
    feature_enabled? :team
  end

  private

  def feature_enabled?(feature)
    features = Rails.application.config.try(:features) || DEFAULT_FEATURES

    features.include? feature.to_s
  end
end
