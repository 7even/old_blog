class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author, :class_name => 'User'
  
  validates_presence_of :title, :body
  
  START_MONTH = 201106
  
  default_scope order('id DESC')
  
  scope :created_on, lambda { |year, month|
    year, month = year.to_i, month.to_i
    start = Date.new(year, month, 1)
    stop  = Date.new(year, month, -1)
    date_range = (start..stop)
    where(created_at: date_range)
  }
  
  def self.archive_monthes
    years = {}
    (START_MONTH..Time.now.strftime('%Y%m').to_i).each do |month_num|
      month_string = month_num.to_s
      year, month = month_string[0..3], month_string[4..5]
      (years[year.to_i] ||= []) << month.to_i if created_on(year, month).count > 0
    end
    years
  end
  
  def has_comments?
    comments.size > 0
  end
end
