class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: t(".subject")
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: t(".subject")
  end

  def sff_confirmation_required(user)
    @user = user
    mail to: "marcin.dylewski@dylux.net", subject: "Potwierdź opłacenie składek użytkownika #{user.full_name}"
  end

  def sff_confirmed(user)
    @user = user
    mail to: user.email, subject: "Członkostwo SFF potwierdzone" #TODO t
  end
end
