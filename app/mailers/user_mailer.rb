class UserMailer < ActionMailer::Base
  default :from => "noreply@7vn.ru"
  
  HOSTS = {
    :development => '7vn.dev',
    :test        => 'test.host',
    :production  => '7vn.ru'
  }
  
  def confirmation_email(user)
    @user = user
    @url = "http://#{UserMailer.host}/confirm/#{@user.token}"
    mail :to => @user.email, :subject => t('mailer.confirmation.subject')
  end
  
  def self.host
    HOSTS[Rails.env.to_sym]
  end
end
