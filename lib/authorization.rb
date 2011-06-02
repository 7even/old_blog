module Authorization
  module ClassMethods
    SALT_TOKEN = 'ololo_trololo'
    
    def create(attributes)
      attributes[:salt]     = generate_salt
      attributes[:password] = encode_password(attributes[:password], attributes[:salt])
      super(attributes)
    end
    
    def authenticate(email, raw_password)
      user = find_by_email(email)
      if user.present? && user.password_valid?(raw_password)
        user
      else
        nil
      end
    end
    
    def encode_password(raw_password, salt)
      require 'digest/md5'
      Digest::MD5.hexdigest(raw_password + SALT_TOKEN + salt)
    end
    
    def generate_salt
      require 'base64'
      ::Base64.encode64("#{Time.now}|#{rand(666)}")
    end
  end
  
  module InstanceMethods
    def password_valid?(raw_password)
      self.class.encode_password(raw_password, self.salt) == self.password
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
