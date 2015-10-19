class Post < ActiveRecord::Base
  validates :body, :user_id, presence: true

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :feeds, as: :item

  TIMELINE_LIMIT = 10

  def self.check_byte(str)
    # return string byte without blank
    body_bytes = str.delete(' ').bytesize
    body_bytes <= 30 ? true : false
  end

  private

  after_save do
    Feed.create(item_type: self.class.name, item_id: self.id)
  end
end
