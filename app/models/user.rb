class User < ActiveRecord::Base
  validates :username, :email, :password, presence: true
  validates :username, length: { maximum: 20 }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one :api_key

  def self.encrypt_password(password)
    Digest::SHA1.hexdigest(password)
  end
end