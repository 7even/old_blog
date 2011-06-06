class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author, :class_name => 'User'
  
  validates_presence_of :title, :body
  
  def has_comments?
    comments.size > 0
  end
end
