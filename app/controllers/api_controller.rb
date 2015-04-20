class ApiController < ApplicationController

  respond_to json: [:regist, :login]

  skip_before_filter :verify_authenticity_token

  def initialize
    @result = { server_time: Time.now.to_i, }
  end

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

    at = ApiKey.generate_access_token(@user.id)
    @user.create_api_key(access_token: at)

    @result.merge!(access_token: @user.api_key.access_token)

    append_user_data
    success
  end

  def login
    email = params[:email] unless params[:email].nil?
    password = params[:password] unless params[:password].nil?

    return error('인자가 올바르지 않습니다.') if email.nil? || password.nil?

    @user = User.find_by_email(email)

    if @user.nil?
      return error('사용자의 정보가 없습니다.')       
    else
      if @user.password == User.encrypt_password(params[:password])
        if @user.api_key.nil?
          at = ApiKey.generate_access_token(@user.id)
          @user.create_api_key(access_token: at)
        end

        @result.merge!(access_token: @user.api_key.access_token,)

        append_user_data
        success
      else
        return error('비밀번호가 올바르지 않습니다.')
      end
    end
  end

  def append_user_data
    @result.merge!(
      user: {
        id: @user.id,
        username: @user.username,
      }
    )
  end

  def error(message)
    @result = {
      success: false,
      error: {
        message: message,
      }
    }

    render json: @result
  end

  def success
    render json: @result.merge!(success: true)
  end

end
