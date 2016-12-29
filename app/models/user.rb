class User < ApplicationRecord
  before_save :encrypt_password
  before_save :downcase_email
  after_save :clear_password

  has_many :blogs, dependent: :destroy
  has_many :active_relationships,  class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy

  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :password
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, :presence => true, :uniqueness => true, :length => { :in => 3..20 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true
  validates_length_of :password, :in => 6..20, :on => :create

  def follow(other_user)
    active_relationships.create(follower_id: self.id, followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(follower_id: self.id, followed_id: other_user.id).destroy
  end

  def following?(other_user)
    followings.include?(other_user)
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

  private
    def encrypt_password
      if password.present?
        self.salt = BCrypt::Engine.generate_salt
        self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
      end
    end

    def downcase_email
      self.email = email.downcase
    end
end
