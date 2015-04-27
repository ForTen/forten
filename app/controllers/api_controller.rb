class ApiController < ApplicationController

  before_action :check_access_token, except: [:regist, :login]
  skip_before_filter :verify_authenticity_token

  
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

  ########################################################
  #                          post                        #
  ########################################################
  def get_post
    post_id = params[:id]

    return error('인자가 올바르지 않습니다.') if post_id.nil?

    @post = @user.posts.find_by_id(post_id)

    append_post_data
    success
  end

  def create_post
    body = params[:body]
    
    return error('인자가 올바르지 않습니다.') if body.nil?
    return error('글자수가 초과 되었습니다.') unless Post.check_byte(body)

    @post = @user.posts.create(body: body)

    append_post_data
    success
  end

  def destroy_post
    post = Post.find_by_id(params[:id])
    post_owner = post.user_id

    return error('게시물의 소유주가 아닙니다.') unless post_owner == @user.id

    post.destroy

    success
  end

  def timeline
    posts = Post.all.reverse_order.limit(@timeline_limit)
    post_list = []

    posts.each do |p|
      post_list.push({ id: p.id, body: p.body })
    end

    @result.merge!(posts: post_list)

    success
  end

  def read_more
    @timeline_limit += 10

    posts = Post.all.reverse_order.offset(@timeline_limit - 10).limit(@timeline_limit)
    
    post_list = []

    posts.each do |p|
      post_list.push({ id: p.id, body: p.body })
    end

    @result.merge!(posts: post_list)

    success
  end
end
