require 'spec_helper'

describe UsersController do
  before(:each) do
    @user = User.create(:email => 'mail@example.com', :password => 'secret', :name => 'ololo', :token => '123')
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => @user.id
      response.should be_success
    end
  end
  
  describe "GET 'login'" do
    it "should be successful" do
      get 'login'
      response.should be_success
    end
  end
  
  describe "POST 'login'" do
    context "with valid credentials" do
      it "should authorize user" do
        post 'login', :email => @user.email, :password => 'secret'
        session[:user_id].should_not be_nil
        response.should redirect_to(root_path)
      end
    end
    
    context "with invalid credentials" do
      it "should not let user in" do
        post 'login', :email => 'ololo@lol.com', :secret => 'iamwrong'
        session[:user_id].should be_nil
        response.should redirect_to(login_path)
        flash[:alert].should == I18n.t('users.invalid_credentials')
      end
    end
  end
  
  describe "GET 'logout'" do
    it "should erase user_id from session" do
      post 'login', :email => @user.email, :password => 'secret'
      @request.env['HTTP_REFERER'] = 'http://test.host/' # для redirect_to :back
      get 'logout'
      session[:user_id].should be_nil
      response.should redirect_to(:back)
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
      assigns(:user).should be_a(User)
    end
  end
  
  describe "GET 'create'" do
    context "with valid attributes" do
      it "should be successful" do
        user_attributes = {'email' => 'ololo@lol.com', 'password' => 'secret'}
        user = stub('user', :save => true).as_null_object # вместо as_null_object нужно реализовать token
        User.should_receive(:new).with(user_attributes).and_return(user)
        get 'create', :user => user_attributes
        response.should redirect_to(root_path)
        flash[:notice].should == I18n.t('users.confirm_please')
      end
    end
    
    context "with invalid attributes" do
      it "should render new" do
        user_attributes = {'email' => 'wrong'}
        user = stub('user', :save => false)
        User.should_receive(:new).with(user_attributes).and_return(user)
        get 'create', :user => user_attributes
        response.should render_template('new')
      end
    end
  end
  
  describe "GET 'confirm'" do
    context "with valid token" do
      it "should be successful" do
        get 'confirm', :token => @user.token
        assigns(:success).should be_true
      end
    end
    
    context "with invalid token" do
      it "should not be successful" do
        get 'confirm', :token => 'ololo'
        assigns(:success).should be_false
      end
    end
    
    context "without token" do
      it "should return 403" do
        get 'confirm'
        response.code.to_i.should == 403
      end
    end
  end
  
  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @user.id
      response.should be_success
    end
  end
  
  describe "GET 'update'" do
    context "with valid attributes" do
      it "should be successful" do
        get 'update', :id => @user.id
        response.should redirect_to(edit_user_path(@user))
        flash.now[:notice].should == I18n.t('users.saved')
      end
    end
    
    context "with invalid attributes" do
      it "should be successful" do
        get 'update', :id => @user.id, :user => {:email => ''}
        response.should be_success
        flash.now[:notice].should be_nil
      end
    end
  end
  
  describe "GET 'destroy'" do
    it "should be successful" do
      get 'destroy', :id => @user.id
      response.should redirect_to(root_path)
      flash[:notice].should == I18n.t('users.destroyed')
    end
  end
end
