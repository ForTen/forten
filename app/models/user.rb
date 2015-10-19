class User < ActiveRecord::Base
  validates :username, :email, :password, presence: true
  validates :username, length: { minimum: 4, maximum: 12 }
  validates_uniqueness_of :email

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :user_pictures, dependent: :destroy
  has_many :feeds, as: :item
  has_one :api_key, dependent: :destroy

  scope :by_access_token, -> (at) { joins(:api_key).where("api_keys.access_token = #{at}") }

  def self.encrypt_password(password)
    Digest::SHA1.hexdigest(password)
  end
end
