Rails.application.routes.draw do
  Rails.application.routes.draw do
    mount ApiTaster::Engine => "/api_taster" if Rails.env.development?
  end

  # API
  post 'api/regist' => 'regist#regist'
  post 'api/login' => 'login#login'

  # POST
  get 'api/posts/:id' => 'post#show'
  post 'api/posts' => 'post#create'
  delete 'api/posts/:id' => 'post#destroy'

  # COMMENT
  get 'api/comments/:id' => 'comment#show'
  post 'api/comments' => 'comment#create'
  delete 'api/comments/:id' => 'comment#destroy'

  # LIKE
  post 'api/likes' => 'like#create'
  delete 'api/likes/:id' => 'like#destroy'

  # TIMELINE
  get 'api/timeline' => 'timeline#timeline'
  get 'api/timeline/read_more' => 'timeline#read_more'
end
