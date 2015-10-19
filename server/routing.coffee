Router.route '/posts/:__slug',
  name: 'showPostPermalink'
  template: '_post'
  layoutTemplate: 'blogLayout'
  data: -> Posts.findOne slug: @params.__slug
, where: 'server'