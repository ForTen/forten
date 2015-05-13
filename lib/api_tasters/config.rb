if Rails.env.development?
  ApiTaster.routes do
    desc 'Get a __list__ of users'

    post '/api/regist', {
      email: '',
      password: '',
      password_repeat: '',
      username: ''
    }

    post '/api/login', {
      email: '',
      password: ''
    }

    get '/api/posts/:id', {
      id: '',
      access_token: '',
    }

    post '/api/posts', {
      access_token: '',
      body: ''
    }

    delete '/api/posts/:id', {
      access_token: '',
      id: ''
    }

    get '/api/comments/:id', {
      access_token: '',
      id: ''
    }

    post '/api/comments', {
      access_token: '',
      body: '',
      id: ''
    }

    delete '/api/comments/:id', {
      access_token: '',
      id: ''
    }

    post '/api/likes', {
      access_token: '',
      id: '',
      type: ''
    }

    delete '/api/likes/:id', {
      access_token: '',
      id: '',
      type: ''
    }

    get '/api/timeline', {
      access_token: '',
    }

    get '/api/timeline/read_more', {
      access_token: '',
    }

  end
end
