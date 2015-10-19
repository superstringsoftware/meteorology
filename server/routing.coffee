Router.route '/posts/:__slug',
  name: 'showPostPermalink'
  template: '_post'
  layoutTemplate: 'blogLayout'
  data: -> Posts.findOne slug: @params.__slug
, where: 'server'

Router.route '/',
  name: 'main'
  template: 'posts'
  data: -> serverPost: Posts.findOne({}, sort: createdAt: -1)
  layoutTemplate: 'blogLayout'
, where: 'server'