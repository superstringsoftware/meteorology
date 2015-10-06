class @TypedCollection
  # encapsulating Mongo Collection and storing DataType for checks
  constructor: (name, dataType)->
    @meteorCollection = new Mongo.Collection name
    @dataType = dataType

  # checking that doc is of correct type then inserting only data
  insert: (doc)->
    check doc, @dataType
    @meteorCollection.insert doc.__getData()

  # returning a TypedCursor that has the same API as a Cursor but wraps it for some functions
  find: (selector, options)->
    #console.log "Find", selector, options
    selector = {} unless selector?
    mcur = @meteorCollection.find selector, options
    new TypedCursor mcur, @dataType, @

  # very dumb findOne() implementation
  # TODO: optimize to insert limit:1 into options
  findOne: (selector, options)-> (@find selector, options).fetch()[0]