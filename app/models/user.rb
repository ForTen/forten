class User < ActiveRecord::Base
  validates :username, :email, :password, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  def self.encrypt_password(password)
  end
end
