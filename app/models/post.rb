class Post < ActiveRecord::Base
  validates :body, :user, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  def self.check_byte(str)
    # return string byte without blank
    str.delete(' ').bytesize
  end
end
