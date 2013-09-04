Router.map ->
  @route 'main', path: '/', controller: MainPageController
  @route 'about'
  @route "posts"
  @route "showPost",
    path: "/posts/:_id",
    controller: PostController

  @route "test",
    path: "/posts/:year/:month/:day/:name",
    controller: PostController

  @route "newPost",
    controller: NewPostController,
    action: 'runWithCheck'



