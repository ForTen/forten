class CommentController < ApplicationController
  before_action :check_access_token

  def show
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

  def create
    post_id = params[:id]
    body = params[:body]

    return error('글 번호가 올바르지 않습니다.') if post_id.nil? || Post.find_by_id(post_id).nil?
    return error('댓글의 내용이 올바르지 않습니다.') if body.nil?
    return error('글자수가 초과 되었습니다.') unless Post.check_byte(body)

    @comment = @user.comments.create(body: body, post_id: post_id)

    append_comments_data({ id: @comment.id, body: @comment.body, owner: @comment.user_id })

    success
  end

  def destroy
    comment = Comment.find_by_id(params[:id])
    comment_owner = comment.user_id

    return error('댓글의 소유주가 아닙니다.') unless comment_owner == @user.id

    comment.destroy

    success
  end
end
