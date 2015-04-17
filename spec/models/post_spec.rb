require 'rails_helper'
require 'spec_helper'

RSpec.describe Post, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:wonjae)
    @post = FactoryGirl.create(:sad_post, user_id: @user.id)
  end

  context '#create' do
    context 'success' do
      it 'body is presence' do
        expect(FactoryGirl.build(:sad_post, body: 'good', user_id: @user.id)).to be_valid
      end

      it 'user_id is presence' do
        expect(FactoryGirl.build(:sad_post, user_id: @user.id)).to be_valid
      end
    end

    context 'fail' do
      it 'body is presence' do
        expect(FactoryGirl.build(:sad_post, body: '')).not_to be_valid
      end

      it 'user_id is presence' do
        expect(FactoryGirl.build(:sad_post, user_id: '')).not_to be_valid
      end
    end
  end

  context '.assocation' do
    it 'should belong_to user' do
      t = Post.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end

    it 'should have many comments' do
      t = Post.reflect_on_association(:comments)
      expect(t.macro).to eq(:has_many)
    end

    it 'should have many likes' do
      t = Post.reflect_on_association(:likes)
      expect(t.macro).to eq(:has_many)
    end
  end

  context '#check_byte' do
    context 'success' do
      it 'should shorter than 30 bytes' do
        expect(Post.check_byte('it is shorter than 30 byte')).to eq(true)
      end
    end

    context 'fail' do
      it 'should shorter than 30 bytes' do
        expect(Post.check_byte('it is more than 30 byte ahahahahahahahahahahahah ahahahahah blabla')).to eq(false)
      end
    end
  end

  context '#destroy' do
    it 'comments should destroy with post' do
      user = FactoryGirl.create(:wonjae)
      post = FactoryGirl.create(:sad_post, user_id: user.id)
      comment = FactoryGirl.create(:sad_comment, user_id: user.id, post_id: post.id)

      post.destroy

      expect(Comment.find_by_id(comment.id)).to eq(nil)
    end

    it 'likes should destroy with post' do
      user = FactoryGirl.create(:wonjae)
      post = FactoryGirl.create(:sad_post, user_id: user.id)
      like = FactoryGirl.create(:one_like_one_love, user_id: user.id, post_id: post.id)

      post.destroy

      expect(Like.find_by_id(like.id)).to eq(nil)
    end
  end
end
