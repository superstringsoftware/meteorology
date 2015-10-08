tl = Observatory.getToolbox()

Template._newPost.rendered = ->
  tl.debug "rendered() called", 'Template.newPost'

Template._newPost.events
  'click #lnkDelete': (e,tmpl) ->
    p = tmpl.data.post
    Posts.remove p._id
    Router.go Router.path('posts')

  'click #lnkCancel': (evt, tmpl)->
    id = tmpl.data.post._id
    console.log "clicked cancel", id
    Router.go('showPost', {_id: tmpl.data.post._id})

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
    p.createdDateString = $('#createdDate').val()

    #console.log p
    # TODO: add validation notifications
    return if (p.title.trim() is '') or (p.body.trim() is '')
    Template.newPost.savePost p
    Router.go('showPost', {_id: p._id})


Template._newPost.savePost = (post)->
  tl.debug 'Saving post', 'NewPostController'
  p = post
  p.slug = escape p.title if p.slug.trim() is ''
  cd = p.createdDateString.split('/')
  #console.log p
  # editing creation date
  cdn = []
  cdn.push parseInt(i,10) for i in cd
  #console.log cd[0].trim
  ts = if cd[0].trim() is '' then new Date() else new Date(cdn[0],cdn[1]-1,cdn[2])

  p.createdAt =
    timestamp: ts
    year: ts.getFullYear()
    month: ts.getMonth() + 1
    day: ts.getDate()
    slug: p.slug # ugly hack to make Router.pathFor work

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
        createdAt: p.createdAt
  else
    p.published = true
    p.createdBy = Meteor.userId()
    p._id = Posts.insert p
  console.log "Saving and navigating", p
  #Router.go Router.path('showPost', _id: p._id)
  #Router.go('showPost', {_id: p._id})