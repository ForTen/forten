Rails.application.routes.draw do
  # API
  post 'api/regist' => 'api#regist'
  post 'api/login' => 'api#login'
end
