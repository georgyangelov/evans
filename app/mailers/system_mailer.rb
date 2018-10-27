class SystemMailer < ActionMailer::Base
  default from: Language.email_sender, reply_to: Language.system_email

  def lectures_build_error(backtrace)
    @backtrace = backtrace

    mail to: Language.system_email, subject: 'Грешка при build на лекциите'
  end
end
