require 'spec_helper'

describe Statistics do
  before(:each) do
    @params = {controller: 'posts', action: 'show', id: 1}
    @env    = {
      'REMOTE_ADDR'     => '127.0.0.1',
      'HTTP_USER_AGENT' => 'torMozilla',
      'HTTP_REFERER'    => 'google.com',
      'PATH_INFO'       => '/posts/1'
    }
    @user = User.create!(email: '7@7vn.ru', password: 'secret', name: 'admin')
  end
  
  describe ".log" do
    it "creates a statistics object" do
      expect {
        Statistics.log(@params, @env, @user)
      }.to change { Statistics.count }
    end
  end
  
  describe ".find_page_id" do
    it "returns correct page_id for correct controller/action" do
      Statistics.send(:find_page_id, controller: 'users', action: 'index').should == 7
    end
    
    it "returns nil for incorrect controller/action" do
      Statistics.send(:find_page_id, controller: 'shit', action: 'happens').should be_nil
    end
  end
end
