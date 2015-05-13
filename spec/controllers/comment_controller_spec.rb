require 'rails_helper'

RSpec.describe CommentController, type: :controller do
  describe '#show' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @at = ApiKey.generate_access_token(@user.id)
      @user.create_api_key(access_token: @at)
      @post = @user.posts.create(body: '테스트당 헤헤') 
      (1..10).each do |i|
        @post.comments.create(body: "테스트#{i}", user_id: @user.id)
      end
    end

    it 'without access_token' do
      get :show, { id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'with invalid access_token' do
      get :show, { access_token: @at + @at, id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'with all params' do
      get :show, { access_token: @at, id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end

  describe '#create' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @at = ApiKey.generate_access_token(@user.id)
      @user.create_api_key(access_token: @at)
      @post = @user.posts.create(body: '테스트당 헤헤') 

      @short_body = "테스트 작성중"
      @long_body = "테스트 작성중 하하하하 30바이트 넘었다"
    end

    it 'body less than 30 bytes' do
      post :create, { access_token: @at, id: @post.id, body: @short_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end

    it 'body more than 30 bytes' do
      post :create, { access_token: @at, id: @post.id, body: @long_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'without access_token' do
      post :create, { id: @post.id, body: @short_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'with invalid access_token' do
      post :create, { access_token: @at + @at, id: @post.id, body: @short_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'without comment body' do
      post :create, { access_token: @at, id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end
  end

  describe '#destroy' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @user2 = FactoryGirl.create(:minsoo)

      @at = ApiKey.generate_access_token(@user.id)
      @at2 = ApiKey.generate_access_token(@user2.id)

      @user.create_api_key(access_token: @at)
      @user2.create_api_key(access_token: @at2)

      @post = @user.posts.create(body: '테스트당 헤헤') 

      @comment = @user.comments.create(body: '테스트당 헤헤', post_id: @post.id) 
      @comment2 = @user2.comments.create(body: '테스트당 헤헤', post_id: @post.id) 
    end

    it 'not owner' do
      post :destroy, { access_token: @at, id: @comment2.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'owner' do
      post :destroy, { access_token: @at, id: @comment.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end
end
