require 'rails_helper'

RSpec.describe LikeController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:wonjae)
    @at = ApiKey.generate_access_token(@user.id)
    @user.create_api_key(access_token: @at)
    @post = @user.posts.create(body: '테스트당 헤헤') 
    @comment = @user.comments.create(body: '테스트 히히', post_id: @post.id)
    @like = @post.likes.create(user_id: @user.id)
  end

  describe '#create' do
    it 'already like' do
      post :create, { access_token: @at, id: @post.id, type: 'post' }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'post is not found' do
      post :create, { access_token: @at, id: @post.id + 1, type: 'post' }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'comment is not found' do
      post :create, { access_token: @at, id: @comment.id + 1, type: 'comment' }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'success' do
      post :create, { access_token: @at, id: @comment.id, type: 'comment' }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end

  describe '#destroy' do
    it 'not owner' do
      post :destroy, {access_token: @at + @at, id: @post.id, type: 'post' }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end 

    it 'not liked' do
      post :destroy, {access_token: @at, id: @comment.id, type: 'comment' }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'success' do
      post :destroy, {access_token: @at, id: @post.id, type: 'post' }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end
end
