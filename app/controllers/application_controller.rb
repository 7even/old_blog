class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?
  
  before_filter :log_statistics
  
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
  
  def log_statistics
    Statistics.log(params, request.env, current_user)
  end
end
