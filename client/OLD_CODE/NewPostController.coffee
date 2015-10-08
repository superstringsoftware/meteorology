tl = Observatory.getToolbox()

class @NewPostController extends RouteController
  template: "newPost"

  onBeforeRun: ->

  waitOn: ->
    tl.debug "Waiting on subscription..."
    CommonController.getSubscription 'userData'

  runWithCheck: ->
    #t = allowAdmin(Meteor.userId())
    s = CommonController.getSubscription 'userData'
    tl.debug "runWithCheck called with for " + s.ready()
    #console.dir Meteor.user()
    #@redirect('/') unless allowAdmin(Meteor.userId())
    @render()

  data: ->
    tl.debug "data() called with params", 'NewPostController'
    #debugger
    console.log @params
    data =
      title: 'New Post'
    if @params._id?
      post = Posts.findOne @params._id
      data.title = 'Edit Post'
    else
      post =
        title: ''
        tagline: ''
        credit: ''
        link: ''
        categories: []
        mainCategory: 'post'
        published: false
        tags: []
        body: ''

    #Session.set "currentPost", post
    data.post = post
    data

  run: ->
    tl.debug "run() called", 'NewPostController'
    super





