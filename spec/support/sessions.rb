def sign_in(user)
  if user.nil?
    return
  end

  if defined? page
    page.set_rack_session UserSession::COOKIE_USER_ID_NAME => user.id
  elsif defined? post and (!defined? controller or controller.nil?)
    post session_path, params: { user: { username: user.username, password: user.password } }
  elsif defined? session
    session[UserSession::COOKIE_USER_ID_NAME] = user.id
  else
    raise "Session access not supported."
  end
end
