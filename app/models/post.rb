class Post < ActiveRecord::Base
  has_many :comments
  
  validates_presence_of :title, :body
  
  def has_comments?
    comments.size > 0
  end
end
