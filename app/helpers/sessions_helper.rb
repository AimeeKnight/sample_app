module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
    # sets the sessions instance current_user attribute in the db
    # The purpose of this line is to create current_user, accessible in both controllers and views, which will allow constructions such as redirect_to current_user
    # above is an assignment, which we must define
    # invokes current_user=(user), passing in the assigned user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
  	@current_user = user
  	#sets an instance variable @current_user, effectively storing the user for later use.
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  	#After the cookie is set, on subsequent page views we can find the user corresponding to the remember token created
  end

    def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
    #removes the remember token from the session
  end
end
