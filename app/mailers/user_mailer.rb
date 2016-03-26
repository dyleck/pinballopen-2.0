class UserMailer < ApplicationMailer

  SKARBNIK = "marcin.dylewski@dylux.net"
  DEV = "marcin.dylewski@dylux.net"
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
    mail to: user.email, subject: "Członkostwo SFF potwierdzone"
  end

  def bank_transfer_info(order)
    @user = order.user
    @order = order
    mail to: @user.email, subject: "#{t(".subject")}#{@order.id}"
  end

  def confirm_payment(order)
    @user = order.user
    @order = order
    mail to: [UserMailer::SKARBNIK, UserMailer::DEV], subject: "PPO 2016 - potwierdź płatność, id: #{@order.id}, user: #{@user.full_name}"
  end

  def payment_confirmed(order)
    @order = order
    @user = @order.user
    I18n.locale = @order.locale.to_sym
    mail to: @user.email, subject: t(".subject")
  end
end
