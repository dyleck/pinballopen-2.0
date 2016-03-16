module UsersHelper
  def is_activated?
    current_user.activated?
  end
end
