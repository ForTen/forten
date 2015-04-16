class ApiKey < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :user
  validates_uniqueness_of :access_token

  private

  def self.generate_access_token(user_id)
    Time.now.to_i.to_s + user_id.to_s
  end
end
