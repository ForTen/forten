# Forten API

## Regist

**Url**

POST /api/regist

**Parameter**

- email
- password
- password_repeat
- username

**Return**

*success*

```javascript
{ 
  success: true,
  access_token: @access_token,
  user: { id: @user.id, username: @user.username }
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**

- 인자가 올바르지 않습니다.
- 비밀번호가 서로 일치하지 않습니다.
- 회원가입에 실패하였습니다.

## Login

**Url**

POST /api/login

**Parameter**

- email
- password

**Return**

*success*

```javascript
{ 
  success: true,
  access_token: @access_token,
  user: { id: @user.id, username: @user.username }
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**

- 인자가 올바르지 않습니다.
- 사용자의 정보가 없습니다.
- 비밀번호가 올바르지 않습니다.

## Post

### Get post

**Url**

GET /api/posts/:id

**Parameter**

- access_token
- id

**Return**

*success*

```javascript
{ 
  success: true,
  post: { id: @post.id, body: @post.body }
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**

- 토큰이 올바르지 않습니다.
- 사용자의 정보가 없습니다.
- 인자가 올바르지 않습니다.

### Create post

**Url**

POST /api/posts

**Parameter**

- access_token
- body

**Return**

*success*

```javascript
{ 
  success: true,
  post: { id: @post.id, body: @post.body }
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**

- 토큰이 올바르지 않습니다.
- 사용자의 정보가 없습니다.
- 인자가 올바르지 않습니다.
- 글자수가 초과 되었습니다.

### Destroy post

**Url**

DELETE /api/posts/:id

**Parameter**

- access_token
- id

**Return**

*success*

```javascript
{ 
  success: true,
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**

- 토큰이 올바르지 않습니다.
- 사용자의 정보가 없습니다.
- 게시물의 소유주가 아닙니다.

## Comment

### Get comments

**Url**

GET /api/comments/:id

**Parameter**

- access_token
- id

**Return**

*success*

```javascript
{ 
  success: true,
  comments: [{ id: @comment.id, body: @comment.body }, { id: @comment2.id, body: @comment.body }, ...]
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**

- 토큰이 올바르지 않습니다.
- 사용자의 정보가 없습니다.
- 글 번호가 올바르지 않습니다.

### Create comment

**Url**

POST /api/comments

**Parameter**

- access_token
- id
- body

**Return**

*success*

```javascript
{ 
  success: true,
  comments: { id: @comment.id, body: @comment.body }
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**

- 토큰이 올바르지 않습니다.
- 사용자의 정보가 없습니다.
- 글 번호가 올바르지 않습니다.
- 댓글의 내용이 올바르지 않습니다.
- 글자수가 초과 되었습니다.

### Destroy comment

**Url**

DELETE /api/comments/:id

**Parameter**

- access_token
- id

**Return**

*success*

```javascript
{ 
  success: true,
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**

- 토큰이 올바르지 않습니다.
- 사용자의 정보가 없습니다.
- 댓글의 소유주가 아닙니다.

## Timeline

### Timeline

**Url**

GET /api/timeline

**Parameter**

- access_token

**Return**

*success*

```javascript
{ 
  success: true,
  posts: [{ id: @post.id, body: @post.body }, { id: @post2.id, body: @post2.body }, ...]
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**

### Read more

**Url**

GET /api/timeline/read_more

**Parameter**

- access_token

**Return**

*success*

```javascript
{ 
  success: true,
  posts: [{ id: @post.id, body: @post.body }, { id: @post2.id, body: @post2.body }, ...]
}
```

*fail*

```javascript
{ 
  success: false,
  error: {
    message: @message,
  }
}
```

**Error Messages**