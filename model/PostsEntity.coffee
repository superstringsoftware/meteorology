# Persistent model class, shared between the server and the client
# encapsulates posts collection and business logic over it

@tb = Observatory.getToolbox() # get Toolbox for logging

class @PostsEntity

  constructor: ->
    tb.debug "PostsEntity constructor"
    @postsCollection = new Mongo.Collection 'posts'

    ###########################################################################
    # Server specific
    ###########################################################################
    if Meteor.isServer
      # setting security on the collection
      @postsCollection.allow
        insert: (uid, doc)=> @_allowInsert uid
        update: (uid, doc)=> @_allowUpdate uid, doc.ownerId
        remove: (uid, doc)=> @_allowRemove uid, doc.ownerId

      # Publishing
      # TODO: will need to change for configurable publish with different parameters
      pc = @postsCollection # _self = this
      Meteor.publish 'currentPosts',->
        tb.debug "Publishing posts for user #{@userId}"
        pc.find {}, sort: 'createdAt.timestamp': -1

    ###########################################################################
    # Client specific
    ###########################################################################
    if Meteor.isClient
      Meteor.subscribe 'currentPosts'


  # simply delegating to the collection
  find: (selector, options) ->
    tb.debug "calling PostsEntity.find(#{EJSON.stringify(selector)}, #{EJSON.stringify(options)})"
    @postsCollection.find selector, options

  ###########################################################################
  # "Private" methods
  ###########################################################################
  # security methods - probably should go to a separate security class eventually
  _allowInsert: (uid)->
    ret = if Meteor.users.findOne(uid)?.securityProfile?.globalRole in ["admin", "editor"] then true else false
    msg = "Returning " + ret + " from _allowInsert for " + uid
    tb.debug msg
    ret
  _allowUpdate: (uid, ownerId)->
    role = Meteor.users.findOne(uid)?.securityProfile?.globalRole
    ret = if (role is 'admin') or (uid is ownerId) then true else false
    msg = "Returning " + ret + " from _allowUpdate for " + uid + " and owner " + ownerId
    tb.debug msg
    ret
  _allowRemove: (uid, ownerId)=>
    ret = @_allowUpdate uid, ownerId
    msg = "Returning " + ret + " from _allowRemove for " + uid + " and owner " + ownerId
    tb.debug msg
    ret