class TimelineController < ApplicationController
  before_action :check_access_token

  def timeline
    posts = Post.all.reverse_order.limit(@timeline_limit)
    post_list = []

    posts.each do |p|
      post_list.push({ id: p.id, body: p.body, owner: p.user_id })
    end

    @result.merge!(posts: post_list)

    success
  end

  def read_more
    return error('인자가 올바르지 않습니다.') if params[:page].nil?

    offset = params[:page].to_i * @timeline_limit
    more_posts = Post.all.reverse_order.offset(offset).limit(@timeline_limit)
    more_posts_count = more_posts.length

    return error('글이 더이상 없습니다.') if more_posts_count == 0

    post_list = []

    more_posts.each do |p|
      post_list.push({ id: p.id, body: p.body, owner: p.user_id })
    end

    @result.merge!(posts: post_list)

    success
  end
end
