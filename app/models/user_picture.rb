class UserPicture < ActiveRecord::Base
  belongs_to :user

  has_attached_file :picture,
    styles: {
      thumb: "200x200#",
      icon: "30x30#"
    }

  validates_attachment_content_type :picture, content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
end
