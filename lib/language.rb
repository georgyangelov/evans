module Language
  extend self

  delegate :language,
           :parsing?,
           :run_tests,
           :extension,
           :solution_dump,
           :can_lint?,
           :lint,
           :test_file_pattern,
           to: :current_language

  def current_language
    @current_language ||= const_get Rails.application.config.language.to_s.camelize
  end

  def course_name
    Rails.application.config.course_name
  end

  def email
    Rails.application.config.course_email
  end

  def system_email
    Rails.application.config.try(:system_email) || email
  end

  def email_sender
    sender = Rails.application.config.try(:course_email_sender) || email

    "#{course_name} <#{sender}>"
  end

  def domain
    Rails.application.config.course_domain
  end
end
