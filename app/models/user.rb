class User < ApplicationRecord
  before_save :encrypt_password
  after_save :clear_password

  has_many :blogs, dependent: :destroy

  attr_accessor :password
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true
  validates_length_of :password, :in => 6..20, :on => :create

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end

  def authenticate?(password)
    return BCrypt::Engine.hash_secret(password, self.salt) == self.encrypted_password
  end

  def gen_token
    Digest::SHA1.hexdigest(self.email + self.salt)
  end
end