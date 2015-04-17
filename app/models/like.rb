class Like < ActiveRecord::Base
  validates :user_id, presence: true

  belongs_to :user
  belongs_to :post
  belongs_to :comment
end
