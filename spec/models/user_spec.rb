require 'spec_helper'

describe User do
  subject { User.create(:email => 'mail@example.com', :password => 'secret', :name => 'ololo') }
  
  it { should validate_presence_of(:email).with_message    error_for(:user, :email) }
  it { should validate_presence_of(:password).with_message error_for(:user, :password) }
  it { should validate_presence_of(:name).with_message error_for(:user, :name) }
  it { should validate_uniqueness_of(:email).with_message  error_for(:user, :email, :taken) }
  
  describe ".create" do
    it "generates a salt" do
      subject.salt.should_not be_nil
      subject.salt.length.should == 41
    end
    
    it "encodes the password" do
      subject.password.should_not be_nil
      subject.password.length.should == 32
    end
  end
  
  describe ".authenticate" do
    context "with valid credentials" do
      it "authenticates a user" do
        User.authenticate(subject.email, 'secret').should_not be_nil
      end
    end
    
    context "with invalid credentials" do
      it "returns nil" do
        User.authenticate(subject.email, 'wrong_pass').should be_nil
        User.authenticate('ololo@lol.com', 'secret').should be_nil
      end
    end
  end
end
