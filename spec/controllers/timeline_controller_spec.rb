require 'rails_helper'

RSpec.describe TimelineController, type: :controller do
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

    it 'no more posts' do
      (@user.posts.length / 10 + 1).times do
        post :read_more, { access_token: @at }
      end

      body = JSON.parse(response.body)

      expect(body['success']).to eq(false)
    end

    it 'get correct posts' do
      post :read_more, { access_token: @at, page: 1 }

      body = JSON.parse(response.body)

      expect(body['success']).to eq(true)
    end
  end
end
