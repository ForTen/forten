class ApiKey < ActiveRecord::Base
  validates_uniqueness_of :user
  validates_uniqueness_of :access_token

  validates :access_token, :user_id, presence: true
  belongs_to :user

  def self.generate_access_token(user_id)
    Time.now.to_i.to_s + user_id.to_s
  end
end
