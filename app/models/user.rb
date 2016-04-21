class User < ActiveRecord::Base
  attr_accessor :password
  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  # validates :password, :confirmation => true #password_confirmation attr
  validates :password,
     on: :create,
     presence: true,
     confirmation: true,
     allow_blank: true,
     length: {:in => 6..20, :message => ": 6 ~ 20 자리 이내로 입력해 주십시오."}

  before_save :encrypt_password
  after_save :clear_password

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
    end
  end
  def clear_password
    self.password = nil
  end

end
