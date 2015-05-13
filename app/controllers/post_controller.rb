class PostController < ApplicationController
  before_action :check_access_token

  def show
    post_id = params[:id]

    return error('인자가 올바르지 않습니다.') if post_id.nil?

    @post = @user.posts.find_by_id(post_id)

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
    post = Post.find_by_id(params[:id])
    post_owner = post.user_id

    return error('게시물의 소유주가 아닙니다.') unless post_owner == @user.id

    post.destroy

    success
  end
end
