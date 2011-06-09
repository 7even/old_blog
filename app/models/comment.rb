class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :author, :class_name => 'User'
  has_ancestry
  
  validates_presence_of :content
end
