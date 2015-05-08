class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def initialize
    @timeline_limit = Post::TIMELINE_LIMIT
    @result = { server_time: Time.now.to_i, }
  end

  def check_access_token
    at = params[:access_token]
    return error('토큰이 올바르지 않습니다.') if at.nil?

    @user = User.by_access_token(at).first
    return error('사용자 정보가 없습니다.') if @user.nil?
  end
  
  private

  def append_user_data
    @result.merge!(user: { id: @user.id, username: @user.username, })
  end

  def append_post_data
    @result.merge!(post: { id: @post.id, body: @post.body, owner: @post.user_id, })
  end

  def append_comments_data(comment_list)
    @result.merge!(comments: comment_list )
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
