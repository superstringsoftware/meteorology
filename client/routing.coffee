Router.route 'posts', path: '/'
Router.route "showPost",
  path: "/posts/:_id",
  controller: PostController
Router.route "newPost",
  controller: NewPostController
Router.route "editPost",
  controller: NewPostController
  path: '/editPost/:_id',




Router.map ->



  @route "showPostPermalink",
    path: "/posts/:year/:month/:day/:slug",
    controller: PostController







