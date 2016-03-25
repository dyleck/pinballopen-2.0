# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

  def sff_confirmation_required
    user = User.first
    UserMailer.sff_confirmation_required(user)
  end

  def sff_confirmed
    user = User.first
    UserMailer.sff_confirmed(user)
  end

  def bank_transfer_info
    order = Order.last
    UserMailer.bank_transfer_info(order)
  end

  def confirm_payment
    order = Order.last
    UserMailer.confirm_payment(order)
  end

  def payment_confirmed
    order = Order.last
    UserMailer.payment_confirmed(order)
  end
end
