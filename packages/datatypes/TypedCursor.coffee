# Wrapper over Mongo.Cursor
# we are not exposing iteration and observe methods as there's not much use in them (currently, at least)
# However, might need iteration in templates - need to experiment and think
class @TypedCursor
  constructor: (cursor, dataType, collection)->
    @meteorCursor = cursor
    @dataType = dataType
    @collection = collection

  # iterating over cursor, creating a proper Typed document for each "dumb" document
  # and returning an array
  fetch: ->
    res = []
    @meteorCursor.forEach (doc)=>
      typedDoc = new @dataType
      typedDoc.__fromData doc
      typedDoc._collection = @collection
      #typedDoc._isPersistent = true
      res.push typedDoc
    res

  count: -> @meteorCursor.count()