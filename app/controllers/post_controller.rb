class PostController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_access_token
  before_action :check_post_exists, except: [:create]

  def show
    append_post_data
    success
  end

  def create
    body = params[:body]

    return error('인자가 올바르지 않습니다.') if body.nil?
    return error('글자수가 초과 되었습니다.') unless Post.check_byte(body)

    @post = @user.posts.create(body: body)

    append_post_data
    success
  end

  def destroy
    post_owner = @post.user_id

    return error('게시물의 소유주가 아닙니다.') unless post_owner == @user.id

    @post.destroy

    success
  end

  private

  def check_post_exists
    @post = Post.find_by_id(params[:id])
    return error('해당글이 존재하지 않습니다.') if @post.nil?
  end
end
