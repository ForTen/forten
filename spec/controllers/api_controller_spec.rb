require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  before(:each) do
    @email = 'test@test.com'
    @password = 'asdfaa'
    @username = 'akkiros'
  end
  
  describe '#regist' do
    context 'fail' do
      it 'email is nil' do
        post :regist, { password: @password, password_repeat: @password, username: @username }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(false)
      end

      it 'password is nil' do
        post :regist, { email: @email, password_repeat: @password, username: @username }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(false)
      end

      it 'password is not match password_repeat' do
        post :regist, { email: @email, password: '1234qwer', password_repeat: @password, username: @username }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(false)
      end

      it 'username is nil' do
        post :regist, { email: @email, password: @password, password_repeat: @password }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(false)
      end

      it 'email is not uniqueness' do
        @user = FactoryGirl.create(:wonjae)

        post :regist, { email: @email, password: @password, password_repeat: @password, username: @username }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(false)

        @user.destroy
      end
    end

    context 'success' do
      it 'have all unique params' do
        post :regist, { email: @email, password: @password, password_repeat: @password, username: @username }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(true)
      end
    end
  end

  describe '#login' do
    context 'fail' do
      it 'email is nil' do
        password = '1234qwer'

        post :login, { password: password }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(false)
      end

      it 'password is nil' do
        email = 'test@test.com'

        post :login, { email: email }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(false)
      end

      it 'email is not match' do
        email = 'test@tt.com'
        password = @password

        post :login, { email: email, password: password }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(false)
      end

      it 'password is not match' do
        email = @email
        password = '1234qwer'

        post :login, { email: email, password: password }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(false)
      end
    end

    context 'success' do
      it 'email and password are match' do
        user = FactoryGirl.create(:wonjae)

        email = @email
        password = @password

        post :login, { email: email, password: password }

        body = JSON.parse(response.body)

        expect(body['success']).to eq(true)
      end
    end
  end

  describe '#get_post' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @at = ApiKey.generate_access_token(@user.id)
      @user.create_api_key(access_token: @at)
      @post = @user.posts.create(body: '테스트당 헤헤') 
    end

    it 'without access_token' do
      get :get_post, { id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'with invalid access_token' do
      get :get_post, { access_token: @at + @at, id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'with all params' do
      get :get_post, { access_token: @at, id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end

  describe '#create_post' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @at = ApiKey.generate_access_token(@user.id)
      @user.create_api_key(access_token: @at)

      @short_body = "테스트 작성중"
      @long_body = "테스트 작성중 하하하하 30바이트 넘었다"
    end

    it 'body less than 30 bytes' do
      post :create_post, { access_token: @at, body: @short_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end

    it 'body more than 30 bytes' do
      post :create_post, { access_token: @at, body: @long_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'without access_token' do
      post :create_post, { body: @short_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'with invalid access_token' do
      post :create_post, { access_token: @at + @at, body: @short_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'without post body' do
      post :create_post, { access_token: @at }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end
  end

  describe '#destroy_post' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @user2 = FactoryGirl.create(:minsoo)

      @at = ApiKey.generate_access_token(@user.id)
      @at2 = ApiKey.generate_access_token(@user2.id)

      @user.create_api_key(access_token: @at)
      @user2.create_api_key(access_token: @at2)

      @post = @user.posts.create(body: '테스트당 헤헤') 
      @post2 = @user2.posts.create(body: '테스트당 헤헤') 
    end

    it 'not owner' do
      post :destroy_post, { access_token: @at, id: @post2.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'owner' do
      post :destroy_post, { access_token: @at, id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end

  describe '#get_comments' do
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
      get :get_comments, { id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'with invalid access_token' do
      get :get_comments, { access_token: @at + @at, id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'with all params' do
      get :get_comments, { access_token: @at, id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end

  describe '#create_comment' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @at = ApiKey.generate_access_token(@user.id)
      @user.create_api_key(access_token: @at)
      @post = @user.posts.create(body: '테스트당 헤헤') 

      @short_body = "테스트 작성중"
      @long_body = "테스트 작성중 하하하하 30바이트 넘었다"
    end

    it 'body less than 30 bytes' do
      post :create_comment, { access_token: @at, id: @post.id, body: @short_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end

    it 'body more than 30 bytes' do
      post :create_comment, { access_token: @at, id: @post.id, body: @long_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'without access_token' do
      post :create_comment, { id: @post.id, body: @short_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'with invalid access_token' do
      post :create_comment, { access_token: @at + @at, id: @post.id, body: @short_body }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'without comment body' do
      post :create_comment, { access_token: @at, id: @post.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end
  end

  describe '#destroy_comment' do
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
      post :destroy_comment, { access_token: @at, id: @comment2.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'owner' do
      post :destroy_comment, { access_token: @at, id: @comment.id }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end

  describe '#create_like' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @at = ApiKey.generate_access_token(@user.id)
      @user.create_api_key(access_token: @at)
      @post = @user.posts.create(body: '테스트당 헤헤') 
      @comment = @user.comments.create(body: '테스트 히히', post_id: @post.id)
      @like = @post.likes.create(user_id: @user.id)
    end

    it 'already like' do
      post :create_like, { access_token: @at, id: @post.id, type: 'post' }

      body = JSON.parse(response.body)
      puts body

      expect(body['success']).to eq(false)
    end

    it 'post is not found' do
      post :create_like, { access_token: @at, id: @post.id + 1, type: 'post' }

      body = JSON.parse(response.body)
      puts body

      expect(body['success']).to eq(false)
    end

    it 'comment is not found' do
      post :create_like, { access_token: @at, id: @comment.id + 1, type: 'comment' }

      body = JSON.parse(response.body)
      puts body

      expect(body['success']).to eq(false)
    end

    it 'success' do
      post :create_like, { access_token: @at, id: @comment.id, type: 'comment' }

      body = JSON.parse(response.body)
      puts body

      expect(body['success']).to eq(true)
    end
  end

  describe '#destroy_like' do
  end

  describe '#timeline' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @at = ApiKey.generate_access_token(@user.id)
      @user.create_api_key(access_token: @at)

      (1..20).each do |i|
        @user.posts.create(body: "테스트 #{i}")
      end
    end

    it 'get correct posts' do
      post :timeline, { access_token: @at }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end

  describe '#read_more' do
    before(:each) do
      @user = FactoryGirl.create(:wonjae)
      @at = ApiKey.generate_access_token(@user.id)
      @user.create_api_key(access_token: @at)

      (1..20).each do |i|
        @user.posts.create(body: "테스트 #{i}")
      end
    end

    it 'get correct posts' do
      post :read_more, { access_token: @at }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end
end
