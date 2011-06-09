class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author, :class_name => 'User'
  
  validates_presence_of :title, :body
  
  scope :created_on, lambda { |year, month|
    year, month = year.to_i, month.to_i
    start = Date.new(year, month, 1)
    stop  = Date.new(year, month, -1)
    date_range = (start..stop)
    where(created_at: date_range)
  }
  
  def has_comments?
    comments.size > 0
  end
end
