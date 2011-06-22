class Statistics < ActiveRecord::Base
  belongs_to :user
  
  PAGES = {
    posts: {
      index:        1,
      show:         2,
      new:          3,
      edit:         4,
      archive:      5,
      full_archive: 6
    },
    users: {
      index:        7,
      show:         8,
      new:          9,
      edit:         10
    },
    static_pages: {
      contacts:     11,
      about:        12
    }
  }
  
  MY_IPS = ['77.37.200.18']
  
  scope :real,   where('ip NOT IN ?',    MY_IPS)
  scope :recent, where('created_at > ?', 1.day.ago)
  
  def self.log(params, env, user)
    # puts "params = #{params[:controller]}##{params[:action]}"
    # puts "env = #{env['REMOTE_ADDR']} / #{env['HTTP_USER_AGENT']} / #{env['HTTP_REFERER']} / #{env['PATH_INFO']}"
    if page_id = self.find_page_id(params)
      create! page_id: page_id,
          resource_id: params[:id],
                   ip: env['HTTP_X_REAL_IP'] || env['REMOTE_ADDR'],
            useragent: env['HTTP_USER_AGENT'],
             referrer: env['HTTP_REFERER'],
                 path: env['PATH_INFO'],
                 user: user
    end
  end
private
  def self.find_page_id(params)
    return nil unless params[:controller].present? && params[:action].present?
    
    begin
      PAGES[params[:controller].to_sym][params[:action].to_sym]
    rescue # на всякий случай
      nil
    end
  end
end
