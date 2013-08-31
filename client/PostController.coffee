tl = TLog.getLogger()
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
  if not @myCodeMirror?
    @myCodeMirror = CodeMirror.fromTextArea document.getElementById("lb_code_console"),
      mode:  "coffeescript"
      theme: "solarized" #"ambiance" #
      readOnly: true


Template.showPost.helpers
  # here we take one paragraph from the post body and format it properly
  format: ->
    console.dir this
    switch @type
      when "markdown" then markdown = @content
      when "html", "text" then html = "<p>#{@content}</p>"
      else html = "<textarea id='lb_code_console'>#{@content}</textarea>"
    markdownContent: markdown, html: html



