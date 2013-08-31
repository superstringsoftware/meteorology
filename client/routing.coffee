Router.map ->
  @route 'main', path: '/', controller: MainPageController
  @route 'about'
  @route "posts"
  @route "showPost",
    path: "/posts/:_id",
    controller: PostController




