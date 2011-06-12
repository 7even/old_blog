require 'spec_helper'

describe UsersController do
  before(:each) do
    @admin = User.create! email: 'admin@7vn.ru',
                       password: 'secret',
                           name: 'admin',
                      confirmed: true,
                          admin: true
    
    @user = User.create email: 'mail@example.com',
                     password: 'secret',
                         name: 'ololo',
                        token: '123',
                    confirmed: true
  end
  
  def login_admin
    session[:user_id] = @admin.id
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      login_admin
      get :index
      response.should be_success
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      get :show, id: @user.id
      response.should be_success
    end
  end
  
  describe "GET 'login'" do
    it "should be successful" do
      get :login
      response.should be_success
    end
  end
  
  describe "POST 'login'" do
    context "with valid credentials" do
      context "for confirmed user" do
        it "should authorize user" do
          User.should_receive(:authenticate).and_return(@user)
          post :login, email: @user.email, password: 'secret'
          session[:user_id].should_not be_nil
          response.should redirect_to(root_path)
        end
      end
      
      context "for not confirmed user" do
        it "should return a message" do
          User.should_receive(:authenticate).and_return(:not_confirmed)
          post :login, email: @user.email, password: 'secret'
          session[:user_id].should be_nil
          response.should render_template('login')
          flash[:alert].should == I18n.t('users.not_confirmed')
        end
      end
    end
    
    context "with invalid credentials" do
      it "should not let user in" do
        User.should_receive(:authenticate).and_return(nil)
        post :login, email: 'ololo@lol.com', secret: 'iamwrong'
        session[:user_id].should be_nil
        response.should render_template('login')
        flash[:alert].should == I18n.t('users.invalid_credentials')
      end
    end
  end
  
  describe "GET 'logout'" do
    it "should erase user_id from session" do
      post :login, email: @user.email, password: 'secret'
      @request.env['HTTP_REFERER'] = 'http://test.host/' # для redirect_to :back
      get :logout
      session[:user_id].should be_nil
      response.should redirect_to(:back)
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
      assigns(:user).should be_a(User)
    end
  end
  
  describe "POST 'create'" do
    context "with valid attributes" do
      it "should be successful" do
        user_attributes = {'email' => 'ololo@lol.com', 'password' => 'secret'}
        user = stub('user', :save => true).as_null_object # вместо as_null_object нужно реализовать token
        User.should_receive(:new).with(user_attributes).and_return(user)
        post :create, user: user_attributes
        response.should redirect_to(root_path)
        flash[:notice].should == I18n.t('users.confirm_please')
      end
    end
    
    context "with invalid attributes" do
      it "should render new" do
        user_attributes = {'email' => 'wrong'}
        user = stub('user', :save => false)
        User.should_receive(:new).with(user_attributes).and_return(user)
        post :create, user: user_attributes
        response.should render_template('new')
      end
    end
  end
  
  describe "GET 'confirm'" do
    context "with valid token" do
      before(:each) do
        get :confirm, token: @user.token
      end
      
      it "should be successful" do
        response.should_not redirect_to(root_path)
      end
      
      it "should set user as confirmed" do
        assigns(:user).confirmed.should be_true
      end
      
      it "should login user" do
        session[:user_id].should == @user.id
      end
    end
    
    context "with invalid token" do
      it "should redirect to root with alert" do
        get :confirm, token: 'ololo'
        response.should redirect_to(root_path)
        flash[:alert].should == I18n.t('layout.invalid_token')
      end
    end
  end
  
  describe "GET 'edit'" do
    it "should be successful" do
      login_admin
      get :edit, id: @user.id
      response.should be_success
    end
  end
  
  describe "PUT 'update'" do
    context "with valid attributes" do
      context "by admin" do
        before(:each) do
          login_admin
        end
        
        it "should be successful" do
          put :update, id: @user.id, user: {name: 'my new name'}
          response.should redirect_to(edit_user_path(@user))
          flash.now[:notice].should == I18n.t('users.saved')
        end
      end
      
      context "by user" do
        before(:each) do
          session[:user_id] = @user.id
        end
        
        it "should be successful" do
          put :update, id: @user.id, user: {old_password: 'secret', new_password: 'very_secret'}
          response.should redirect_to(edit_user_path(@user))
          flash.now[:notice].should == I18n.t('users.saved')
        end
      end
    end
    
    context "with invalid attributes" do
      before(:each) do
        session[:user_id] = @user.id
      end
      
      it "should be successful" do
        put :update, id: @user.id, user: {name: ''}
        response.should_not redirect_to(root_path)
        response.should render_template(:edit)
        flash.now[:notice].should be_nil
      end
    end
  end
  
  describe "DELETE 'destroy'" do
    it "should be successful" do
      login_admin
      delete :destroy, id: @user.id
      response.should redirect_to(root_path)
      flash[:notice].should == I18n.t('users.destroyed')
    end
  end
end
