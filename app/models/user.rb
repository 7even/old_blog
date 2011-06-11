class User < ActiveRecord::Base
  has_many :posts,    :foreign_key => :author_id, :dependent => :delete_all
  has_many :comments, :foreign_key => :author_id, :dependent => :delete_all
  
  validates_presence_of :email, :password, :name
  validates_uniqueness_of :email
  
  include Authorization
  
  def wrote_posts?
    posts.count > 0
  end
end
