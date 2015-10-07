class @TypedCollection
  # encapsulating Mongo Collection and storing DataType for checks
  constructor: (name, dataType, autopublish = true)->
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
    @meteorCollection.insert doc.__getData()

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

  # straightforward and pretty universal publish
  publishFind: ->
    return unless Meteor.isServer
    Meteor.publish "#{@name}_subscription", (selector, options)=>
      selector = {} unless selector?
      options = {} unless options?
      #console.log "publishing with", selector, options
      @meteorCollection.find selector, options

  # subscribe corresponding to publishFind()
  subscribeFind: (selector, options) ->
    return if Meteor.isServer
    @_handle?.stop()
    @_handle = Meteor.subscribe "#{@name}_subscription", selector, options