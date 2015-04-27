require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:wonjae)
  end

  context '#create' do
    context 'success' do
      it 'username is presence' do
        expect(FactoryGirl.build(:minsoo, username: 'minsoo1003')).to be_valid
      end

      it 'username is maximum 20 words' do
        expect(FactoryGirl.build(:minsoo, username: 'minsoo1003')).to be_valid
      end

      it 'email is presence' do
        expect(FactoryGirl.build(:minsoo, email: 'test2@test.com')).to be_valid
      end

      it 'password is presence' do
        expect(FactoryGirl.build(:minsoo, password: 'aaaaaa')).to be_valid
      end
    end

    context 'fail' do
      it 'username is presence' do
        expect(FactoryGirl.build(:minsoo, username: '')).not_to be_valid
      end

      it 'username is maximum 20 words' do
        expect(FactoryGirl.build(:minsoo, username: 'asdfasdfasdfasdfasdfa')).not_to be_valid
      end

      it 'email is presence' do
        expect(FactoryGirl.build(:minsoo, email: '')).not_to be_valid
      end

      it 'password is presence' do
        expect(FactoryGirl.build(:minsoo, password: '')).not_to be_valid
      end
      
      it 'email is unique' do
        expect(FactoryGirl.build(:wonjae)).not_to be_valid
      end
    end
  end

  context '.association' do
    it 'should have many posts' do
      t = User.reflect_on_association(:posts)
      expect(t.macro).to eq(:has_many)
    end

    it 'should have many comments' do
      t = User.reflect_on_association(:comments)
      expect(t.macro).to eq(:has_many)
    end

    it 'should have many likes' do
      t = User.reflect_on_association(:likes)
      expect(t.macro).to eq(:has_many)
    end

    it 'should have one api_key' do
      t = User.reflect_on_association(:api_key)
      expect(t.macro).to eq(:has_one)
    end
  end

  context '#encrypt_password' do
    it 'should encrypt using SHA1' do
      expect(User.encrypt_password('asdfaa')).to eq(@user.password)
    end
  end

  context '#destroy' do
    before(:each) do
      @user.destroy
    end

    it 'posts should destroy with user' do
      user = FactoryGirl.create(:wonjae)
      post = FactoryGirl.create(:sad_post, user_id: user.id)

      user.destroy

      expect(Post.find_by_id(post.id)).to eq(nil)
    end

    it 'comments should destroy with user' do
      user = FactoryGirl.create(:wonjae)
      post = FactoryGirl.create(:sad_post, user_id: user.id)
      comment = FactoryGirl.create(:sad_comment, user_id: user.id, post_id: post.id)

      user.destroy

      expect(Comment.find_by_id(comment.id)).to eq(nil)
    end

    it 'likes should destroy with user' do
      user = FactoryGirl.create(:wonjae)
      post = FactoryGirl.create(:sad_post, user_id: user.id)
      like = FactoryGirl.create(:one_like_one_love, user_id: user.id, post_id: post.id)

      user.destroy

      expect(Like.find_by_id(like.id)).to eq(nil)
    end

    it 'api_key should destroy with user' do
      user = FactoryGirl.create(:wonjae)
      api_key = FactoryGirl.create(:wonjae_key, user_id: user.id)

      user.destroy

      expect(ApiKey.find_by_id(api_key.id)).to eq(nil)
    end
  end
end
