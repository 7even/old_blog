require 'spec_helper'

describe ApplicationController do
  before(:each) do
    @user = User.create! email: 'admin@7vn.ru',
                       password: 'secret',
                           name: 'admin',
                      confirmed: true
    session[:user_id] = @user.id
  end
  
  controller do
    def show
      render :nothing => true
    end
  end
  
  it "logs the request into the statistics" do
    Statistics.should_receive(:log).with(
      {'id' => 1, 'controller' => 'stub_resources', 'action' => 'show'},
      hash_including('REMOTE_ADDR' => '127.0.0.1', 'HTTP_USER_AGENT' => 'torMozilla', 'HTTP_REFERER' => 'google.com'),
      @user
    )
    @request.env['REMOTE_ADDR'] = '127.0.0.1'
    @request.env['HTTP_USER_AGENT'] = 'torMozilla'
    @request.env['HTTP_REFERER'] = 'google.com'
    get :show, id: 1
  end
  
  describe ".current_user" do
    it "returns current user" do
      controller.send(:current_user).should == @user
    end
  end
end