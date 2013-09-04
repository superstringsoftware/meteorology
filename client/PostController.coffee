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
    posts: Posts.find {}

  loadingTemplate: 'loading',
  notFoundTemplate: 'notFound'


Template.showPost.rendered = ->
  #@myCodeMirror = null
  return unless @data.post?.body?
  for b in @data.post.body
    doc = document.getElementById("codeParagraph#{b.numInPost}")
    if doc?
      cm1 = CodeMirror.fromTextArea doc,
        mode: b.type
        theme: "solarized" #"ambiance" #
        readOnly: true
      lc = cm1.doc.lineCount()
      lc = 20 if lc > 20
      cm1.setSize(null, 20*lc + 20)


Template.showPost.helpers

  # here we take one paragraph from the post body and format it properly
  format: ->
    #console.log this
    n = @numInPost
    switch @type
      when "markdown" then markdown = @content
      when "html", "text", "htmlmixed" then html = "#{@content}"
      else
        # setting up for codemirror & syntax highlighting for processing in the rendered callback
        html = "<textarea id='codeParagraph#{n}'>#{@content}</textarea>"
    markdownContent: markdown, html: html

Template.showPost.events

  # starting an editor - only if the user can actually edit this
  # for now simply check for admin
  'click .postParagraph': (evt,tmpl)->
    #tl.debug "Clicked on paragraph number #{@numInPost}"
    # for now, only admin can edit posts
    # TODO: change to owners in the future
    return unless allowAdmin(Meteor.userId())
    tmpl.cm.toTextArea() if tmpl.cm?
    n = @numInPost
    doc = document.getElementById("realEditorArea#{n}")
    #console.log doc
    $("#myModal#{@numInPost}").modal()
    tmpl.cm = CodeMirror.fromTextArea doc,
      mode: @type
      theme: "solarized"

  'click .btnSaveChanges': (evt, tmpl)->
    n = $(evt.target).attr 'data-num'
    console.log "Save changes clicked for #{n}"
    content = tmpl.cm.doc.getValue()
    post = tmpl.data.post
    post.body[n].content = content
    $("#myModal#{n}").modal 'hide'
    Posts.update post._id, $set: body: post.body



