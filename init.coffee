tl = tb = Observatory.getToolbox()

@Posts = new TypedCollection 'posts', Post

# security methods - probably should go to a separate security class eventually
@allowInsert = (uid)->
  ret = if Meteor.users.findOne(uid)?.securityProfile?.globalRole in ["admin", "editor"] then true else false
  msg = "Returning " + ret + " from _allowInsert for " + uid
  tb.debug msg
  ret
@allowUpdate = (uid, ownerId)->
  role = Meteor.users.findOne(uid)?.securityProfile?.globalRole
  ret = if (role is 'admin') or (uid is ownerId) then true else false
  msg = "Returning " + ret + " from _allowUpdate for " + uid + " and owner " + ownerId
  tb.debug msg
  ret
@allowRemove = (uid, ownerId)->
  ret = _allowUpdate uid, ownerId
  msg = "Returning " + ret + " from _allowRemove for " + uid + " and owner " + ownerId
  tb.debug msg
  ret

if Meteor.isClient
  #Observatory.subscribe(50)
  #Observatory.logMeteor()
  
  Router.configure
    layoutTemplate: "layout"
    notFoundTemplate: "notFound"
    loadingTemplate: "loading"

  #Observatory.logCollection()
  Observatory.logMeteor()
  #Observatory.logTemplates()

  #CommonController.subscribe 'allPosts'
  CommonController.subscribe 'userData'

  UI.registerHelper "getSession", (name)-> Session.get name
  UI.registerHelper "formatDate", (timestamp)->
    timestamp?.toDateString?()



