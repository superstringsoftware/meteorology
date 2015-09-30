Router.route 'posts', path: '/'
Router.route "showPost",
  path: "/posts/:_id",
  controller: PostController



Router.map ->



  @route "showPostPermalink",
    path: "/posts/:year/:month/:day/:slug",
    controller: PostController


  @route "newPost",
    controller: NewPostController,
    action: 'runWithCheck'
  @route "editPost",
    path: '/editPost/:_id',
    controller: NewPostController,
    action: 'runWithCheck'





