require 'spec_helper'

describe User do
  subject { User.create(:email => 'mail@example.com', :password => 'secret', :name => 'ololo') }
  
  it { should validate_presence_of(:email).with_message    error_for(:user, :email) }
  it { should validate_presence_of(:password).with_message error_for(:user, :password) }
  it { should validate_uniqueness_of(:email).with_message  error_for(:user, :email, :taken) }
end
