Router.map ->
  #@route 'main', path: '/'
  @route "posts", path: '/'
  @route "showPost",
    path: "/posts/:_id",
    controller: PostController

  @route "test",
    path: "/posts/:year/:month/:day/:slug",
    controller: PostController


  @route "newPost",
    controller: NewPostController,
    action: 'runWithCheck'
  @route "editPost",
    path: '/editPost/:_id',
    controller: NewPostController,
    action: 'runWithCheck'





