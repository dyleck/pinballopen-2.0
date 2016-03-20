module UsersHelper
  def is_activated?
    current_user.activated?
  end

  def current_user
    if session[:user_id]
      User.find_by(id: session[:user_id])
    end
  end
end
