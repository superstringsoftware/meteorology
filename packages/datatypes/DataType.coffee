# Base class for all typed classes (to mimic algebraic datatypes in the future plus type checking)
# Can also be persistent if created through a TypedCollection
# Also supports reactivity

class @DataType

  ###
  Even better syntactic shugar:
  class Name
    @typedProperty "name", String - that's it!!
  check - is meteor add check, checks for a pattern and throws an exception if it's not passed
  ###
  @typedProperty: (propName, checkPattern, reactive = false) ->
    privatePropName = "__#{propName}"
    @prototype[privatePropName] = null # defining a new private property on the prototype
    # defining object to store reactive deps for properties
    if reactive
      @prototype.__reactiveDependencies = {} unless @prototype.__reactiveDependencies?
      @prototype.__reactiveDependencies[privatePropName] = new Deps.Dependency # defining dependency if it's a reactive property
      # now defining getter / setter with check() call
      Object.defineProperty @prototype, propName,
        # getter simply returns the private property and establishes dependency
        get: ->
          @__reactiveDependencies[privatePropName].depend()
          @[privatePropName]
      # setters checks for the pattern first and sets changed on dependency
        set: (value)->
          check value, checkPattern
          @__reactiveDependencies[privatePropName].changed() if value isnt @[privatePropName]
          @[privatePropName] = value
    else # simply returning
      Object.defineProperty @prototype, propName,
        # getter simply returns the private property
        get: -> @[privatePropName]
        # setters checks for the pattern first
        set: (value)->
          check value, checkPattern
          @[privatePropName] = value

  @typedProperties: (propNames, checkPattern, reactive = false) ->
    @typedProperty n, checkPattern, reactive for n in propNames

  # saves a document into collection if it's bound to one
  save: ->
    return unless @_collection? # it is set by typedCursor when it retrieves docs from the collection
    @_collection.meteorCollection.update {_id: @_id}, {$set: @__getData()}

  # check if this object was retrieved from a collection and is persistent so that save() can be called on it
  isPersistent: -> if @_collection? then true else false

  ###
  Forces ALL reactive deps to become invalidated (FIXME: this is a workaround for quickly making Arrays pseudo-reactive - need a better solution)
  ###
  __invalidate: ->
    dep.changed() for k, dep of @__reactiveDependencies

  ###
  This method converts all private property names that are like this: __propName
  into "dumb" object (without any getters or setters) with property names like: propName.
  This method needs to be used for saving DataType objects into collections -
  eventually automatically, once we define smart collection class based on DataType
  ###
  __getData: ->
    props = Object.getOwnPropertyNames @
    ret = {}
    for p in props
      pnew = if p.indexOf('__') is 0 then p.substring(2) else p
      # filtering out _id in collection and a reference to collection (set from TypedCursor!!!)
      ret[pnew] = @[p] unless p in ['_id', '_collection']
    ret

  ###
  This function initializes DataType object from the "dumb" object - the same as the one returned by
  __getData()
  It's simpler than __getData() since we have getters / setters with proper names already, so we get
  automatic typechecking as a bonus as well
  ###
  __fromData: (data)->
    @[p] = data[p] for p in Object.getOwnPropertyNames data