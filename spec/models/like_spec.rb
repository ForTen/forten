require 'rails_helper'
require 'spec_helper'

RSpec.describe Like, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:wonjae)
    @post = FactoryGirl.create(:sad_post, user_id: @user.id)
    @comment = FactoryGirl.create(:sad_comment, user_id: @user.id, post_id: @post.id)
  end

  context '#create' do
    context 'success' do
      it 'user_id is presence' do
        expect(FactoryGirl.build(:one_like_one_love, user_id: @user.id)).to be_valid
      end
    end

    context 'fail' do
      it 'user_id is presence' do
        expect(FactoryGirl.build(:one_like_one_love, user_id: '')).not_to be_valid
      end
    end
  end

  context '.association' do
    it 'should belong_to user' do
      t = Like.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end

    it 'should belong_to post' do
      t = Like.reflect_on_association(:post)
      expect(t.macro).to eq(:belongs_to)
    end

    it 'should belong_to comment' do
      t = Like.reflect_on_association(:comment)
      expect(t.macro).to eq(:belongs_to)
    end

    it 'should have many feeds' do
      t = Post.reflect_on_association(:feeds)
      expect(t.macro).to eq(:has_many)
    end
  end
end
