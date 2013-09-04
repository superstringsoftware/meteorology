tl = TLog.getLogger()
class @_newPost extends RouteController
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
    if @params.id?
      post = Posts.findOne @params.id
      b.editing = false for b in post.body
      data.title = 'Edit Post'
      Session.set "editingParagraph", false
    else
      post =
        title: ''
        tagline: ''
        credit: ''
        link: ''
        categories: []
        tags: []
        body: [
          content: ''
          type: 'htmlmixed'
          numInPost: 0
          editing: true
        ]
      Session.set "editingParagraph", 0

    Session.set "currentPost", post
    data.post = post
    data

  run: ->
    tl.debug "run() called", 'NewPostController'
    super

  @savePost: (post)->
    tl.debug 'Saving post', 'NewPostController'
    p = @trimPost post
    if p._id?
      Posts.update p._id,
        $set:
          title: p.title
          tagline: p.tagline
          credit: p.credit
          link: p.link
          categories: p.categories
          tags: p.tags
          body: p.body
          updatedAt: new Date
          updatedBy: Meteor.userId()
    else
      p.createdAt = new Date
      p.createdBy = Meteor.userId()
      p.permalink = "/" + p.createdAt.getFullYear() + "/" + (p.createdAt.getMonth() + 1) + "/" + p.createdAt.getDate() + "/" + p.title.replace(/\s/g, "_")
      Posts.insert p
    #console.dir p



  # if save is true will save changes
  @processPostInMemory: (tmpl, save = false)->
    type = $("#codemirrorType").val()
    tl.debug "processPostInMemory(): #{type}", 'NewPostController'
    content = tmpl.cm.doc.getValue()
    post = tmpl.data.post
    n = Session.get "editingParagraph"
    b.editing = false for b in post.body
    if save
      if content.trim() is '' and n isnt false
        post.body = _.without post.body, post.body[n]
      else post.body[n].content = content; post.body[n].type = type unless n is false

    Session.set "currentPost", @trimPost post
    Session.set "editingParagraph", false

  # removes paragraphs with empty content from the post - usable before saving to collection
  @trimPost: (post)->
    #console.log post
    body = []
    for p in post.body
      body.push p unless p.content.trim() is ''
    post.body = body
    post




Template.newPost.rendered = ->
  tl.debug "rendered() called", 'Template.newPost'
  console.log this
  #console.dir @data
  #@myCodeMirror = null
  for b in @data.post.body
    doc = document.getElementById("codeParagraph#{b.numInPost}")
    if doc?
      options =
        mode: b.type
        theme: "solarized" #"ambiance" #
        readOnly: not b.editing
      if b.editing
        @cm = CodeMirror.fromTextArea doc, options if not cm?
      else
        cm1 = CodeMirror.fromTextArea doc, options
        lc = cm1.doc.lineCount()
        lc = 20 if lc > 20
        cm1.setSize(null, 20*lc)


Template.newPost.helpers
  post: -> Session.get "currentPost"

  # here we take one paragraph from the post body and format it properly
  format: ->
    #console.log this
    n = @numInPost
    if @editing then html = @content
    else
      switch @type
        when "markdown" then markdown = @content
        when "html", "text", "htmlmixed" then html = @content
        else
        # setting up for codemirror & syntax highlighting for processing in the rendered callback
          html = "<textarea id='codeParagraph#{n}'>#{@content}</textarea>"
    markdownContent: markdown, html: html



Template.newPost.events
  # changing the mode of the editor
  'change #codemirrorType': (evt, tmpl)->
    type = $("#codemirrorType").val()
    #console.log type
    tmpl.cm.setOption("mode", type)

  # adding a new paragraph
  'click #lnkNew': (evt, tmpl)->
    post = tmpl.data.post
    b.editing = false for b in post.body
    len = post.body.length
    post.body.push
      content: ''
      type: 'htmlmixed'
      numInPost: len
      editing: true
    Session.set "currentPost", post
    Session.set "editingParagraph", len

  'click #btnCancel': (evt, tmpl)-> NewPostController.processPostInMemory tmpl
  'click #btnSaveChanges': (evt, tmpl)-> NewPostController.processPostInMemory tmpl, true

  # saving post to the database
  # validation is done here - just checking for title now
  'click #lnkPublish': (evt, tmpl)->
    return unless allowAdmin(Meteor.userId())
    p = tmpl.data.post
    p.title = $('#title').val()
    p.tagline = $('#tagline').val()
    p.credit = $('#credit').val()
    p.link = $('#link').val()
    #console.log p
    return if p.title.trim() is ''
    NewPostController.savePost p



