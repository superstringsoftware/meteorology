tl = TLog.getLogger()

class @PostController extends RouteController
  template: "showPost"

  waitOn: CommonController.getSubscription 'allPosts'

  data: ->
    post = Posts.findOne @params._id
    # hack because meteor does not support @index in handlebars
    return unless post?
    b.numInPost = i for b,i in post.body
    #console.dir post
    post: post


class @PostsController extends RouteController
  template: "posts"

  # wait for the posts subscribtion to be ready.
  # In the meantime, the loading template will display
  waitOn: CommonController.getSubscription 'allPosts'

  data: ->
    tl.debug 'data() called', 'PostsController'
    posts: Posts.find()


Template.showPost.rendered = ->
  #@myCodeMirror = null
  doc = document.getElementById("lb_code_console")
  if (not @myCodeMirror?) and (doc?)
    @myCodeMirror = CodeMirror.fromTextArea doc,
      mode:  "coffeescript"
      theme: "solarized" #"ambiance" #
      readOnly: true


Template.showPost.helpers
  canEdit: -> true
  # here we take one paragraph from the post body and format it properly
  format: ->
    console.dir this
    switch @type
      when "markdown" then markdown = @content
      when "html", "text" then html = "#{@content}"
      else html = "<textarea id='lb_code_console'>#{@content}</textarea>"
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


