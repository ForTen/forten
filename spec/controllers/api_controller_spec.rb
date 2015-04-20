require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  before(:each) do
    @email = 'test@test.com'
    @password = 'asdfaa'
    @username = 'akkiros'
  end
  
  context '#regist' do
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

  context '#login' do
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
end
