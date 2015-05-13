class LikeController < ApplicationController
  before_action :check_access_token

  def create
    type = params[:type]

    target = type == 'post' ? Post.find_by_id(params[:id]) : Comment.find_by_id(params[:id])

    return error('해당 글을 찾을 수 없습니다.') if type == 'post' && target.nil?
    return error('해당 댓글을 찾을 수 없습니다.') if type == 'comment' && target.nil?
    return error('이미 좋아요를 눌렀습니다.') unless target.likes.find_by_user_id(@user.id).nil?

    @like = target.likes.create(user_id: @user.id)

    append_like_data
    success
  end

  def destroy
    type = params[:type]
    target = type == 'post' ? Post.find_by_id(params[:id]) : Comment.find_by_id(params[:id])

    return error('해당 글을 찾을 수 없습니다.') if type == 'post' && target.nil?
    return error('해당 댓글을 찾을 수 없습니다.') if type == 'comment' && target.nil?

    @like = target.likes.find_by_user_id(@user.id)

    return error('누른 좋아요가 없습니다.') if @like.nil?

    @like.destroy

    success
  end
end
