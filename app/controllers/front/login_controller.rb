class Front::LoginController < ApplicationController

  def initialize
    @result = { server_time: Time.now.to_i, }
  end

  def login
    email = params[:email] unless params[:email].nil?
    password = params[:password] unless params[:password].nil?

    @user = User.find_by_email(email)

    if @user.nil?
      error('사용자의 정보가 없습니다.')       
    else
      if @user.password == User.encrypt_password(params[:password])
        if @user.api_key.nil?
          at = ApiKey.generate_access_token(@user.id)
          @user.create_api_key(access_token: at)
        end

        @result.merge!(access_token: @user.api_key.access_token,)

        session[:user_id] = @user.id
        session[:is_login] = true

        success
      end
    end
  end

  def error(message)
    @result = {
      success: false,
      error: {
        message: message,
      }
    }
  end

  def success
    render json: @result.merge!(success: true)
  end
end
