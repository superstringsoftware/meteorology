tl = TLog.getLogger()

class @PostController extends RouteController
  template: "showPost"

  waitOn: CommonController.getSubscription 'allPosts'

  data: ->
    return {} unless CommonController.getSubscription('allPosts').ready()
    tl.debug "data() called and subscription is #{CommonController.getSubscription('allPosts').ready()}", 'PostController'
    console.log @params
    post = Posts.findOne @params._id
    console.log post
    post

  loadingTemplate: 'loading',
  notFoundTemplate: 'notFound'


class @PostsController extends RouteController
  template: "posts"

  # wait for the posts subscribtion to be ready.
  # In the meantime, the loading template will display
  waitOn: CommonController.getSubscription 'allPosts'

  data: ->
    tl.debug 'data() called', 'PostsController'
    posts: Posts.find {} #published: true

  loadingTemplate: 'loading',
  notFoundTemplate: 'notFound'


Template.showPost.rendered = ->
  return unless @data.post?.body?


Template.showPost.events

  # starting an editor - only if the user can actually edit this
  # for now simply check for admin
  'dblclick .post': (evt,tmpl)->
    tl.debug "Clicked on post " + tmpl.data._id
    # for now, only admin can edit posts
    # TODO: change to owners in the future
    return unless allowAdmin(Meteor.userId())
    Router.go Router.path('editPost', _id: tmpl.data._id)