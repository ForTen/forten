require 'rails_helper'
require 'spec_helper'

RSpec.describe Comment, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:wonjae)
    @post = FactoryGirl.create(:sad_post, user_id: @user.id)
  end

  context '#create' do
    context 'success' do
      it 'body is presence' do
        expect(FactoryGirl.build(:sad_comment, body: 'good', user_id: @user.id, post_id: @post.id)).to be_valid
      end

      it 'user_id is presence' do
        expect(FactoryGirl.build(:sad_comment, user_id: @user.id, post_id: @post.id)).to be_valid
      end

      it 'post_id is presence' do
        expect(FactoryGirl.build(:sad_comment, user_id: @user.id, post_id: @post.id)).to be_valid
      end
    end

    context 'fail' do
      it 'body is presence' do
        expect(FactoryGirl.build(:sad_comment, body: '')).not_to be_valid
      end

      it 'user_id is presence' do
        expect(FactoryGirl.build(:sad_comment, user_id: '', post_id: @post.id)).not_to be_valid
      end

      it 'post_id is presence' do
        expect(FactoryGirl.build(:sad_comment, user_id: @user.id, post_id: '')).not_to be_valid
      end
    end
  end

  context '.association' do
    it 'should belong_to user' do
      t = Comment.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end

    it 'should belong_to post' do
      t = Comment.reflect_on_association(:post)
      expect(t.macro).to eq(:belongs_to)
    end

    it 'should have many likes' do
      t = Comment.reflect_on_association(:likes)
      expect(t.macro).to eq(:has_many)
    end
  end

  context '#destroy' do
    it 'likes should destroy with comment' do
      comment = FactoryGirl.create(:sad_comment, user_id: @user.id, post_id: @post.id)
      like = FactoryGirl.create(:one_like_one_love, user_id: @user.id, post_id: @post.id, comment_id: comment.id)

      comment.destroy

      expect(Like.find_by_id(like.id)).to eq(nil)
    end
  end
end
