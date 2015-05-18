class TimelineController < ApplicationController
  before_action :check_access_token

  # This is for rspec
  @@last_id = Post.all.length == 0 ? 0 : Post.last.id

  def timeline
    posts = Post.all.reverse_order.limit(@timeline_limit)
    post_list = []

    posts.each do |p|
      post_list.push({ id: p.id, body: p.body, owner: p.user_id })
    end

    @@last_id = posts.last.id
    @result.merge!(posts: post_list)

    success
  end

  def read_more

    @@last_id = Post.last.id if @@last_id.nil? || @@last_id < Post.first.id
    more_posts = Post.all.reverse_order.where("posts.id < #{@@last_id}")
    more_posts_count = more_posts.length

    return error('글이 더이상 없습니다.') if more_posts_count == 0

    posts = more_posts_count < 10 ? more_posts.limit(more_posts_count) : more_posts.limit(@timeline_limit)

    post_list = []

    posts.each do |p|
      post_list.push({ id: p.id, body: p.body, owner: p.user_id })
    end

    @@last_id = posts.last.id
    @result.merge!(posts: post_list)

    success
  end
end
