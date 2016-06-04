module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    user.remember_token = cookies[:remember_token]
  end

  def current_user(options = {})
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user = User.find_by(id: cookies.signed[:user_id]))
      if user && user.authenticated?(:remember, cookies[:remember_token])
        @current_user = user
        session[:user_id] = user.id
      end
    end
    if !options[:only_from_session] && session[:user_switch_id]
      User.find_by(id: session[:user_switch_id])
    else
      @current_user
    end
  end

  def logged_in?
    !current_user(only_from_session: true).nil?
  end

  def admin?
    current_user(only_from_session: true).admin?
  end

  def superadmin?
    current_user.superadmin?
  end

  def redirect_to_login_if_not_logged_in
    if !logged_in?
      session[:display_login] = true
      flash.now[:danger] = "Please log in"
      cookies[:redirect_to] = request.path
      redirect_to root_path
    end
  end

  def user_switched?
    session[:user_switch_id]
  end

  def redirect_to_root_if_not_current_user(param = nil)
    if current_user.id.to_s == params[:id] || current_user.id.to_s == params[:user_id] ||
        ( !param.nil? && current_user.respond_to?(param) && current_user.send(param) )
      return true
    else
      redirect_to root_path
    end
  end

  def redirect_to_root_if_not_admin
    if !logged_in? || !current_user(only_from_session: true).admin?
      redirect_to root_path
    end
  end

  def redirect_to_root_if_not_superadmin_for_superadmin_in_user_params
    if params[:user][:superadmin] && !superadmin?
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
