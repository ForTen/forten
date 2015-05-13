class TimelineController < ApplicationController
  before_action :check_access_token

  @@last_id = Post.last.id

  def timeline
    posts = Post.all.reverse_order.limit(@timeline_limit)
    post_list = []

    posts.each do |p|
      post_list.push({ id: p.id, body: p.body, owner: p.user_id })
    end

    @@last_id = posts.last.id
    Rails.logger.info("last_id : #{@@last_id}")
    @result.merge!(posts: post_list)

    success
  end

  def read_more
    @@last_id = Post.last.id if @@last_id.nil?
    Rails.logger.info("last_id : #{@@last_id}")
    more_posts = Post.all.reverse_order.where("posts.id < #{@@last_id}")
    more_posts_count = more_posts.length

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
