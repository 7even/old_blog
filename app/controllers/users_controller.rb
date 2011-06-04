class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def login
    @user = User.authenticate(params[:email], params[:password])
    
    if @user
      session[:user_id] = @user.id
      redirect_to root_path, :notice => t('users.logged_in')
    else
      redirect_to root_path, :alert => t('users.invalid_credentials')
    end
  end
  
  def logout
    session[:user_id] = nil
    redirect_to root_path, :notice => t('users.logged_out')
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      redirect_to root_path, :notice => t('users.confirm_please')
    else
      render :action => 'new'
    end
  end
  
  def confirm
    render :nothing => true, :status => :forbidden unless params[:token]
    
    user = User.find_by_token(params[:token])
    if user.present? && user.update_attribute(:confirmed, true)
      @success = true
    else
      @success = false
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    flash.now[:notice] = t('users.saved') if @user.update_attributes(params[:user])
    render :action => 'edit'
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, :notice => t('users.destroyed')
  end
end
