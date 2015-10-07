Router.route '/',
  name: 'main'
  waitOn: -> LastPosts.subscription
  data: -> LastPosts.findOne {}, sort: createdAt: -1

Router.route '/posts',
  name: 'posts'
  waitOn: -> Meteor.subscribe "posts_subscription", {}, {}


###
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


###




