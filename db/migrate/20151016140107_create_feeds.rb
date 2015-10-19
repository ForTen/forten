class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
			t.column "item_type", :string
			t.column "item_id", :integer

      t.timestamps
    end
  end
end
