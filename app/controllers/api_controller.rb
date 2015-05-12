class ApiController < ApplicationController

  before_action :check_access_token, except: [:regist, :login]
  # TODO: regist, login일때 server time 안찍힘
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

  ########################################################
  #                       comment                        #
  ########################################################
  def get_comments
    post_id = params[:id]

    return error('글 번호가 올바르지 않습니다.') if post_id.nil? || Post.find_by_id(post_id).nil?

    @post = @user.posts.find_by_id(post_id)
    @comments = @post.comments.all
    comment_list = []

    @comments.each do |c|
      comment_list.push({ id: c.id, body: c.body, owner: c.user_id })
    end

    append_comments_data(comment_list)
    success
  end

  def create_comment
    post_id = params[:id]
    body = params[:body]
    
    return error('글 번호가 올바르지 않습니다.') if post_id.nil? || Post.find_by_id(post_id).nil?
    return error('댓글의 내용이 올바르지 않습니다.') if body.nil?
    return error('글자수가 초과 되었습니다.') unless Post.check_byte(body)

    @comment = @user.comments.create(body: body, post_id: post_id)

    append_comments_data({ id: @comment.id, body: @comment.body, owner: @comment.user_id })

    success
  end

  def destroy_comment
    comment = Comment.find_by_id(params[:id])
    comment_owner = comment.user_id

    return error('댓글의 소유주가 아닙니다.') unless comment_owner == @user.id

    comment.destroy

    success
  end

  ########################################################
  #                        like                          #
  ########################################################
  
  def create_like
    type = params[:type]

    target = type == 'post' ? Post.find_by_id(params[:id]) : Comment.find_by_id(params[:id])

    return error('해당 글을 찾을 수 없습니다.') if type == 'post' && target.nil?
    return error('해당 댓글을 찾을 수 없습니다.') if type == 'comment' && target.nil?
    return error('이미 좋아요를 눌렀습니다.') unless target.likes.find_by_user_id(@user.id).nil?

    @like = target.likes.create(user_id: @user.id)

    append_like_data
    success
  end

  def destroy_like
  end

  ########################################################
  #                      timeline                        #
  ########################################################
  def timeline
    posts = Post.all.reverse_order.limit(@timeline_limit)
    post_list = []

    posts.each do |p|
      post_list.push({ id: p.id, body: p.body, owner: p.user_id })
    end

    @last_id = posts.last.id
    @result.merge!(posts: post_list)

    success
  end

  def read_more
    @last_id = Post.last.id if @last_id.nil?

    posts = Post.all.reverse_order.where("posts.id < #{@last_id}").limit(@timeline_limit)
    
    post_list = []

    posts.each do |p|
      post_list.push({ id: p.id, body: p.body, owner: p.user_id })
    end

    @last_id = posts.last.id
    @result.merge!(posts: post_list)

    success
  end
end
