Router.route '/',
  name: 'main'
  waitOn: -> LastPosts.subscription
  data: -> LastPosts.findOne {}, sort: createdAt: -1
  layoutTemplate: 'mainLayout'

Router.route '/posts',
  name: 'posts'
  waitOn: -> LastPosts.subscription
  data: -> LastPosts.find().fetch()
  layoutTemplate: 'blogLayout'

Router.route '/admin/newPost',
  name: 'admin.newPost'
  template: '_newPost'
  data: -> post: new Post
  waitOn: -> CommonController.subs.userData
  onBeforeAction: ->
    if allowInsert Meteor.userId() then @next() else Router.go '/'

Router.route '/post/:_id',
  name: 'showPostPermalink'
  template: '_post'
  layoutTemplate: 'blogLayout'
  data: -> LastPosts.findOne _id: @params._id


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




