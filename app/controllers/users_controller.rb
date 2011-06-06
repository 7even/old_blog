class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def login
    if request.post?
      @user = User.authenticate(params[:email], params[:password])
      
      if @user
        session[:user_id] = @user.id
        redirect_to root_path
      else
        redirect_to login_path, :alert => t('users.invalid_credentials')
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    redirect_to :back
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save
      UserMailer.confirmation_email(@user).deliver
      redirect_to root_path, :notice => t('users.confirm_please')
    else
      render :action => 'new'
    end
  end
  
  def confirm
    @user = User.find_by_token(params[:token])
    if @user
      @user.update_attribute(:confirmed, true)
      session[:user_id] = @user.id
    else
      redirect_to root_path, :alert => t('layout.invalid_token')
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path(@user), :notice => t('users.saved')
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path, :notice => t('users.destroyed')
  end
end
