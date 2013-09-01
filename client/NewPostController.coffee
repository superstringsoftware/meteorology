tl = TLog.getLogger()

class @NewPostController extends RouteController
  template: "newPost"

  data: ->
    tl.debug "data() called - preparing empty post stub", 'NewPostController'
    post =
      title: ''
      tagline: ''
      credit: ''
      link: ''
      categories: []
      tags: []
      body: [
        content: 'ttt'
        type: 'htmlmixed'
        numInPost: 0
        editing: true
      ]
    Session.set "currentPost", post
    Session.set "editingParagraph", 0
    post: post

  run: ->
    tl.debug "run() called", 'NewPostController'
    super

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
    console.log post
    body = []
    for p in post.body
      body.push p unless p.content.trim() is ''
    post.body = body
    post




Template.newPost.rendered = ->
  tl.debug "rendered() called", 'NewPostController'
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
      else CodeMirror.fromTextArea doc, options


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


