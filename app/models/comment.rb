class Comment < ActiveRecord::Base
  validates :body, :user_id, :post_id, presence: true

  belongs_to :post
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :feeds, as: :item

  private

  after_save do
    Feed.create(item_type: self.class.name, item_id: self.id)
  end
end
