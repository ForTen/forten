require 'rails_helper'

RSpec.describe RegistController, type: :controller do
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
end
