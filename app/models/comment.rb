class Comment < ActiveRecord::Base
  belongs_to :post
  has_ancestry
  
  validates_presence_of :content
end
