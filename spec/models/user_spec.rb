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
    
    it "generates a token" do
      subject.token.should_not be_nil
      subject.token.length.should == 32
    end
  end
  
  describe "#update_attributes" do
    context "with :new_password" do
      it "sets hashed :new_password to the password attribute" do
        expect {
          subject.update_attributes(new_password: 'new secret')
        }.to change { subject.password }
      end
    end
    
    context "without :new_password" do
      it "doesn't touch stored password" do
        expect {
          subject.update_attributes(name: 'bugagalol')
        }.not_to change { subject.password }
      end
    end
  end
  
  describe ".authenticate" do
    context "with valid credentials" do
      it "authenticates a user" do
        subject.update_attribute(:confirmed, true)
        User.authenticate(subject.email, 'secret').should be_a(User)
      end
    end
    
    context "for unconfirmed user" do
      it "returns nil" do
        subject.update_attribute(:confirmed, false)
        User.authenticate(subject.email, 'secret').should == :not_confirmed
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
