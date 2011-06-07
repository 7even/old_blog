class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => t('layout.access_restricted')
  end
protected
  def current_user
    @current_user ||= session[:user_id] ? User.find(session[:user_id]) : nil
  end
  
  def logged_in?
    current_user != nil
  end
end
