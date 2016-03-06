module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    user.remember_token = cookies[:remember_token]
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user = User.find_by(id: cookies.signed[:user_id]))
      if user && user.authenticated?(cookies[:remember_token])
        @current_user = user
        session[:user_id] = user.id
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def admin?
    current_user.admin?
  end

  def redirect_to_login_if_not_logged_in
    if !logged_in?
      flash[:login] = true
      flash.now[:danger] = "Please log in"
      cookies[:redirect_to] = request.path
      redirect_to root_path
    end
  end

  def redirect_to_root_if_not_admin
    if !logged_in? || !current_user.admin?
      redirect_to root_path
    end
  end

  def log_out
    session.delete :user_id
    cookies.delete :user_id
    cookies.delete :remember_token
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.signed.permanent[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    session.delete(:order_id)
  end
end
