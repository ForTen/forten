class LoginController < ApplicationController
  def login
    email = params[:email] unless params[:email].nil?
    password = params[:password] unless params[:password].nil?

    return error('인자가 올바르지 않습니다.') if email.nil? || password.nil?

    @user = User.find_by_email(email)

    return error('사용자의 정보가 없습니다.') if @user.nil?

    unless @user.password == User.encrypt_password(params[:password])
      return error('비밀번호가 올바르지 않습니다.')
    end

    if @user.api_key.nil?
      at = ApiKey.generate_access_token(@user.id)
      @user.create_api_key(access_token: at)
    end

    @result.merge!(access_token: @user.api_key.access_token,)

    append_user_data
    success
  end
end
