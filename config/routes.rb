Rails.application.routes.draw do
  # API
  post 'api/regist' => 'api#regist'
  post 'api/login' => 'api#login'

  get 'api/posts/:id' => 'api#get_post'
  post 'api/posts' => 'api#create_post'
  delete 'api/posts/:id' => 'api#destroy_post'

  get 'api/timeline' => 'api#timeline'
  get 'api/timeline/read_more' => 'api#read_more'
end
