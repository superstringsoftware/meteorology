tl = Observatory.getToolbox()

Template._newPost.rendered = ->
  tl.debug "rendered() called", 'Template.newPost'
  @computation = @autorun -> Template.currentData()
  console.log @computation
  Session.set "_newPost.tags", @data.tags

Template._newPost.helpers
  tags1: -> Session.get "_newPost.tags"

Template._newPost.events
  'click #lnkDelete': (e,tmpl) ->
    p = tmpl.data.post
    Posts.remove p._id
    Router.go Router.path('posts')

  'click #lnkCancel': (evt, tmpl)->
    id = tmpl.data.post._id
    console.log "clicked cancel", id
    Router.go('/posts')

  'keypress #newTag': (evt, tmpl)->
    return unless evt.keyCode is 13
    p = Template.currentData() #tmpl.data.post
    tag = $("#newTag").val()
    #console.log "adding tag to ", p, tag
    #console.log evt
    p.tags.push tag
    console.log p
    Session.set "_newPost.tags", p.tags
    p.__invalidate()
    #tmpl.computation.invalidate()

  # saving post to the database
  # validation is done here - just checking for title now
  'click #lnkPublish': (evt, tmpl)->
    #return unless allowAdmin(Meteor.userId())
    p = tmpl.data.post
    console.log "Saving post", p
    p.title = $('#title').val()
    p.tagline = $('#tagline').val()
    p.credit = $('#credit').val()
    p.link = $('#link').val()
    p.body = $('#body').val()
    p.mainCategory = $('#category').val()
    p.slug = $('#slug').val()
    p.createdAt = new Date
    #p.createdDateString = $('#createdDate').val()

    #console.log p
    # TODO: add validation notifications
    return if (p.title.trim() is '') or (p.body.trim() is '')
    id = Posts.insert p
    Router.go("/post/#{id}")



