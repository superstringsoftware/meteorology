tl = TLog.getLogger()

class @PostController extends RouteController
  template: "showPost"

  waitOn: CommonController.getSubscription 'allPosts'

  data: ->
    return {} unless CommonController.getSubscription('allPosts').ready()
    tl.debug "data() called and subscription is #{CommonController.getSubscription('allPosts').ready()}", 'PostController'
    console.log @params
    if @params._id
      post = Posts.findOne @params._id
    else
      post = Posts.findOne
        slug: @params.slug
        'createdAt.year': parseInt(@params.year, 10)
        'createdAt.month': parseInt(@params.month, 10)
        'createdAt.day': parseInt(@params.day, 10)
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
    #posts: Posts.find {}, sort: 'createdAt.timestamp': -1 #published: true
    posts = (Posts.find {}, sort: 'createdAt.timestamp': -1).fetch() #published: true
    lastPost: posts[0], posts: _.rest posts

  loadingTemplate: 'loading',
  notFoundTemplate: 'notFound'

Template.posts.rendered = ->
  Session.set("loadDisqus", true)

  Deps.autorun ->
    # Load the Disqus embed.js the first time the `disqus` template is rendered
    # but never more than once
    if Session.get("loadDisqus") && !window.DISQUSWIDGETS
      # * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * *
      disqus_shortname = "meteorology" # required: replace example with your forum shortname

      # * * DON'T EDIT BELOW THIS LINE * *
      (->
        s = document.createElement("script")
        #console.log 'attaching counts'
        s.async = true
        s.type = "text/javascript"
        s.src = "//" + disqus_shortname + ".disqus.com/count.js"
        (document.getElementsByTagName("HEAD")[0] or document.getElementsByTagName("BODY")[0]).appendChild s
      )()

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