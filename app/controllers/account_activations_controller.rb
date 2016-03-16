class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    digest = params[:id]
    if user && digest && !user.activated? && user.authenticated?(:activation, digest)
      user.update_attribute :activated, true
      log_in user
      flash[:success] = t(".account.activated")
      redirect_to user
    else
      redirect_to root_url
    end
  end

  def update
    if !(user = current_user).activated?
      user.create_activation_digest
      if user.save
        UserMailer.account_activation(user).deliver_now
        flash[:warning] = t(".link.sent")
        redirect_to user
      end
    end
  end
end
