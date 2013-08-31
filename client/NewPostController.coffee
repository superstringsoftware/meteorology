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
        type: 'text'
        numInPost: 0
        editing: true
      ]
    post: post

  run: ->
    tl.debug "run() called", 'NewPostController'
    super


Template.newPost.rendered = ->
  #@myCodeMirror = null
  for b in @data.post.body
    doc = document.getElementById("codeParagraph#{b.numInPost}")
    if doc?
      cm = CodeMirror.fromTextArea doc,
        mode: b.type
        theme: "solarized" #"ambiance" #
        readOnly: not b.editing
      @cm = cm if b.editing



Template.newPost.helpers
# here we take one paragraph from the post body and format it properly
  format: ->
    #console.log this
    n = @numInPost
    if @editing then html = "<h3>Edit paragraph:</h3><textarea id='codeParagraph#{n}' class='form-control'>#{@content}</textarea>"
    else
      switch @type
        when "markdown" then markdown = @content
        when "html", "text" then html = "#{@content}"
        else
        # setting up for codemirror & syntax highlighting for processing in the rendered callback
          html = "<textarea id='codeParagraph#{n}'>#{@content}</textarea>"
    markdownContent: markdown, html: html


