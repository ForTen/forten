require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  before(:each) do
    @email = 'test@test.com'
    @password = 'asdfaa'
    @username = 'akkiros'
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
end
