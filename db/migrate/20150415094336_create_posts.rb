class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.column "body", :string

      t.references :user, index: true
      t.timestamps
    end
  end
end
