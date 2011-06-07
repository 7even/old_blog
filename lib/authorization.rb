module Authorization
  module ClassMethods
    SALT_TOKEN = 'ololo_trololo'
    
    def authenticate(email, raw_password)
      user = find_by_email(email)
      
      if user.blank? || user.password_invalid?(raw_password)
        nil
      elsif user.confirmed?
        user
      else
        :not_confirmed
      end
    end
    
    def generate_salt
      require 'base64'
      ::Base64.encode64("#{Time.now}|#{rand(666)}")
    end
    
    def encode_password(raw_password, salt)
      require 'digest/md5'
      Digest::MD5.hexdigest(raw_password + SALT_TOKEN + salt)
    end
  end
  
  module InstanceMethods
    def save(*args)
      if self.new_record?
        self.salt     = self.class.generate_salt
        self.password = self.class.encode_password(self.password, self.salt)
        self.token    = self.generate_token
      end
      
      super(*args)
    end
    
    def password_valid?(raw_password)
      self.class.encode_password(raw_password, self.salt) == self.password
    end
    
    def password_invalid?(raw_password)
      !password_valid?(raw_password)
    end
    
    def generate_token
      require 'digest/md5'
      Digest::MD5.hexdigest(self.email + '-\|/-' + self.name)
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
