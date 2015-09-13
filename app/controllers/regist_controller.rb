class RegistController < ApplicationController
  protect_from_forgery with: :null_session

  def regist
    email = params[:email] unless params[:email].nil?
    password = Digest::SHA1.hexdigest(params[:password]) unless params[:password].nil?
    username = params[:username] unless params[:username].nil?

    return error('인자가 올바르지 않습니다.') if email.nil? || password.nil? || username.nil?
    return error('비밀번호가 서로 일치하지 않습니다.') unless params[:password] == params[:password_repeat]

    @user = User.new(email: email, password: password, username: username)

    unless @user.save
      return error('회원 가입에 실패하였습니다.')
    end

    if params.key?(:picture)
      photo = params.permit(:picture)
      pic = @user.user_pictures.new(photo)
      pic.save
    end

    at = ApiKey.generate_access_token(@user.id)
    @user.create_api_key(access_token: at)

    @result.merge!(access_token: @user.api_key.access_token)

    append_user_data
    success
  end
end
