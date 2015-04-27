class Post < ActiveRecord::Base
  validates :body, :user_id, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  TIMELINE_LIMIT = 10 

  def self.check_byte(str)
    # return string byte without blank
    body_bytes = str.delete(' ').bytesize
    body_bytes <= 30 ? true : false
  end
end
