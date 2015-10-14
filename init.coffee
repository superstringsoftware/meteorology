tl = tb = Observatory.getToolbox()

@Posts = new TypedCollection 'posts', Post, true

# security methods - probably should go to a separate security class eventually
@allowInsert = (uid)->
  ret = if Meteor.users.findOne(uid)?.securityProfile?.globalRole in ["admin", "editor"] then true else false
  msg = "Returning " + ret + " from allowInsert for " + uid
  tb.debug msg
  ret
@allowUpdate = (uid, doc)->
  role = Meteor.users.findOne(uid)?.securityProfile?.globalRole
  ret = if (role is 'admin') or (uid is doc.ownerId) then true else false
  msg = "Returning " + ret + " from allowUpdate for " + uid + " and owner " + doc.ownerId
  tb.debug msg
  ret
@allowRemove = (uid, doc)->
  ret = allowUpdate uid, doc
  msg = "Returning " + ret + " from allowRemove for " + uid + " and owner " + doc.ownerId
  tb.debug msg
  ret

Posts.meteorCollection.allow
  insert: allowInsert
  update: allowUpdate
  remove: allowRemove


Observatory.automagical.logCollections()
#Observatory.automagical.logMongoConnection()

if Meteor.isClient
  #Observatory.subscribe(50)
  #Observatory.logMeteor()
  
  Router.configure
    layoutTemplate: "layout"
    notFoundTemplate: "notFound"
    loadingTemplate: "loading"


  Observatory.automagical.logSubscriptions()
  #Observatory.logCollection()
  #Observatory.logTemplates()

  #CommonController.subscribe 'allPosts'
  CommonController.subscribe 'userData'

  UI.registerHelper "getSession", (name)-> Session.get name
  UI.registerHelper "formatDate", (timestamp)->
    timestamp?.toDateString?()

  UI.registerHelper "canEdit", (doc)-> allowUpdate Meteor.userId(), doc



