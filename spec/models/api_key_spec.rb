require 'rails_helper'
require 'spec_helper'

RSpec.describe ApiKey, type: :model do
  before(:each) do
    @user = FactoryGirl.create(:wonjae)
    @access_token = ApiKey.generate_access_token(@user.id)
  end

  context '#create' do
    context 'success' do
      it 'user_id is presence' do
        expect(FactoryGirl.create(:api_key, user_id: @user.id)).to be_valid
      end

      it 'access_token is presence' do
        expect(FactoryGirl.create(:api_key, user_id: @user.id, access_token: @access_token)).to be_valid
      end
    end
  end

=begin
    context 'fail' do
      it 'user_id is presence' do
        expect(FactoryGirl.create(:api_key, user_id: '')).not_to be_valid
      end

      it 'access_token is presence' do
        expect(FactoryGirl.create(:api_key, user_id: @user.id, access_token: '')).not_to be_valid
      end

      it 'user_id should uniqueness' do
        FactoryGirl.create(:api_key, user_id: @user.id)
        expect(FactoryGirl.create(:api_key, user_id: @user.id, access_token: @access_token)).not_to be_valid
      end

      it 'user_id should uniqueness' do
        FactoryGirl.create(:api_key, user_id: @user.id, access_token: '12341234')
        expect(FactoryGirl.create(:api_key, user_id: @user.id.to_i + 1, access_token: '12341234')).not_to be_valid
      end
    end
  end
=end

  context '.assocation' do
    it 'should belongs_to user' do
      t = ApiKey.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
  end

  context '#generate_access_token' do
    it 'access_token made by time and user_id' do
      at = Time.now.to_i.to_s + @user.id.to_s
      expect(ApiKey.generate_access_token(@user.id)).to eq(at)
    end
  end
end
