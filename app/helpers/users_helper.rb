module UsersHelper
  def is_activated?
    current_user.activated?
  end

=begin
  def current_user
    if session[:user_id]
      User.find_by(id: session[:user_id])
    end
  end
=end

  def mark_if_ordered_or_payed(user)
    if user.main_payed?
      return_class = "success"
    elsif user.main_ordered?
      return_class = "warning"
    else
      return_class = "danger"
    end
    return_class += " loggedin" if !current_user.nil? && current_user == user
    return_class
  end
end
