class @TypedCollection
  # encapsulating Mongo Collection and storing DataType for checks
  constructor: (name, dataType, autopublish = false)->
    @meteorCollection = new Mongo.Collection name
    @dataType = dataType
    @name = name
    if autopublish
      if Meteor.isServer
        @publishFind()
      else
        @subscribeFind {}

  # checking that doc is of correct type then inserting only data
  insert: (doc)->
    check doc, @dataType
    doc._id = @meteorCollection.insert doc.__getData()
    # converting the doc that we were inserting into persistent
    # FIXME: check if it was already persistent???
    doc._collection = @
    doc._id

  remove: (selector, callback)->
    @meteorCollection.remove selector, callback

  # returning a TypedCursor that has the same API as a Cursor but wraps it for some functions
  find: (selector, options)->
    #console.log "Find", selector, options
    selector = {} unless selector?
    options = {} unless options?
    mcur = @meteorCollection.find selector, options
    new TypedCursor mcur, @dataType, @

  # very dumb findOne() implementation
  # TODO: optimize to insert limit:1 into options
  findOne: (selector, options)-> (@find selector, options).fetch()[0]


  # publishing custom Find() to the client collection with collectionName
  # this is needed to provide flexibility of having different collections on the client
  # for the same server collection, something Meteor doesn't do for some reason
  # Find() parameters are set on the server
  publishObserve: (collectionName, selector, options) ->
    return unless Meteor.isServer
    col = @meteorCollection
    Meteor.publish "#{collectionName}_subscription", ->
      _self = this
      selector = {} unless selector?
      options = {} unless options?

      handle = (col.find selector, options).observe
        added: (doc)=>
          @added(collectionName, doc._id, doc)

        removed: (doc)=>
          @removed(collectionName, doc._id)

        changed: (oldDoc, newDoc)=>
          @changed(collectionName, newDoc._id, newDoc)

      _self.ready()
      _self.onStop = -> handle.stop()
      return



# publishing custom Find() to the client collection with collectionName
  # this is needed to provide flexibility of having different collections on the client
  # for the same server collection, something Meteor doesn't do for some reason
  # Find() parameters are taken from the client completely
  publishObserveDangerous: (collectionName) ->
    return unless Meteor.isServer
    col = @meteorCollection
    Meteor.publish "#{collectionName}_subscription", (selector, options)->
      _self = this
      selector = {} unless selector?
      options = {} unless options?

      handle = (col.find selector, options).observe
        added: (doc)=>
          @added(collectionName, doc._id, doc)

        removed: (doc)=>
          @removed(collectionName, doc._id)

        changed: (oldDoc, newDoc)=>
          @changed(collectionName, newDoc._id, newDoc)

      _self.ready()
      _self.onStop = -> handle.stop()
      return

  # straightforward and pretty universal publish
  # TODO: DANGEROUS - no checks on client parameters so can find anything. Better to use publishObserve. Or rethink
  # TODO: (cont'd) how to combine server and client filters
  publishFind: ->
    return unless Meteor.isServer
    Meteor.publish "#{@name}_subscription", (selector, options)=>
      selector = {} unless selector?
      options = {} unless options?
      #console.log "publishing with", selector, options
      @meteorCollection.find selector, options

  # subscribe function that stores handle in our object
  subscribe: (colName, selector, options) ->
    return if Meteor.isServer
    @subscription?.stop()
    @subscription = Meteor.subscribe "#{colName}_subscription", selector, options

  subscribeFind: (selector, options)-> @subscribe @name, selector, options