tl = TLog.getLogger()

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

    Session.set "currentPost", post
    data.post = post
    data

  run: ->
    tl.debug "run() called", 'NewPostController'
    super

  @savePost: (post)->
    tl.debug 'Saving post', 'NewPostController'
    p = post
    if p.slug.trim() is ''
      p.slug = escape p.title
    if p._id?
      Posts.update p._id,
        $set:
          title: p.title
          tagline: p.tagline
          credit: p.credit
          link: p.link
          categories: p.categories
          mainCategory: p.mainCategory
          tags: p.tags
          body: p.body
          slug: p.slug
          updatedAt: new Date
          updatedBy: Meteor.userId()
    else
      ts = new Date
      p.createdAt =
        timestamp: ts
        year: ts.getFullYear()
        month: ts.getMonth() + 1
        day: ts.getDate()
        slug: p.slug # ugly hack to make Router.pathFor work
      published: true
      p.createdBy = Meteor.userId()
      p._id = Posts.insert p
    console.dir p
    Router.go Router.path('showPost', _id: p._id)


Template.newPost.rendered = ->
  tl.debug "rendered() called", 'Template.newPost'

Template.newPost.helpers
  post: -> Session.get "currentPost"

Template.newPost.events
  'click #lnkCancel': (evt, tmpl)-> Router.go Router.path('showPost', _id: tmpl.data.post._id)

  # saving post to the database
  # validation is done here - just checking for title now
  'click #lnkPublish': (evt, tmpl)->
    return unless allowAdmin(Meteor.userId())
    p = tmpl.data.post
    p.title = $('#title').val()
    p.tagline = $('#tagline').val()
    p.credit = $('#credit').val()
    p.link = $('#link').val()
    p.body = $('#body').val()
    p.mainCategory = $('#category').val()
    p.slug = $('#slug').val()
    console.log p
    # TODO: add validation notifications
    return if (p.title.trim() is '') or (p.body.trim() is '')
    NewPostController.savePost p


