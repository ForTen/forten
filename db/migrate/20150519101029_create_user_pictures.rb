class CreateUserPictures < ActiveRecord::Migration
  def change
    create_table :user_pictures do |t|
      t.string   "picture_file_name"
      t.string   "picture_content_type"
      t.integer  "picture_file_size"
      t.datetime "created_at"
      t.datetime "updated_at"

      t.references :user, index: true
      t.timestamps
    end
  end
end
