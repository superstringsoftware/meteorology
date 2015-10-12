tl = Observatory.getToolbox()

Template._newPost.rendered = ->
  tl.debug "rendered() called", 'Template.newPost'

Template._newPost.events
  'click #lnkDelete': (e,tmpl) ->
    p = Template.currentData()
    Posts.remove p._id
    Router.go '/blog'

  'click #lnkCancel': (evt, tmpl)->
    #id = tmpl.data.post._id
    #console.log "clicked cancel", id
    Router.go('/blog')

  'keypress #newTag': (evt, tmpl)->
    return unless evt.keyCode is 13
    p = Template.currentData()
    tag = $("#newTag").val()
    p.tags = [] unless p.tags?
    p.tags.push tag
    #console.log p
    $("#newTag").val("")
    p.__invalidate() # to force template re-run after tag array change


  # saving post to the database
  # validation is done here - just checking for title now
  'click #lnkPublish': (evt, tmpl)->
    #return unless allowAdmin(Meteor.userId())
    p = Template.currentData()
    #console.log p

    #console.log "Saving post", p
    p.title = $('#title').val()
    p.tagline = $('#tagline').val()
    #p.credit = $('#credit').val()
    #p.link = $('#link').val()
    p.body = $('#body').val()
    p.mainCategory = $('#category').val()
    p.slug = $('#slug').val()

    # TODO: add validation notifications
    return if (p.title.trim() is '') or (p.body.trim() is '')

    if p.isPersistent()
      p.updatedAt = new Date
      p.save()
      id = p._id
    else
      p.createdAt = new Date
      p.ownerId = Meteor.userId()
      id = Posts.insert p

    #p.createdDateString = $('#createdDate').val()
    #console.log p
    Router.go("/post/#{id}")



