class User < ActiveRecord::Base
  validates_presence_of :email, :password, :name
  validates_uniqueness_of :email
  
  include Authorization
end
