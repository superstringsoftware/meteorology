# Base class for all typed classes (to mimic algebraic datatypes in the future plus type checking)
# Can also be persistent if created through a TypedCollection

class @DataType

  ###
  Even better syntactic shugar:
  class Name
    @typedProperty "name", String - that's it!!
  check - is meteor add check, checks for a pattern and throws an exception if it's not passed
  ###
  @typedProperty: (propName, checkPattern) ->
    privatePropName = "__#{propName}"
    @prototype[privatePropName] = null # defining a new private property on the prototype
    # now defining getter / setter with check() call
    Object.defineProperty @prototype, propName,
      # getter simply returns the private property
      get: -> @[privatePropName]
    # setters checks for the pattern first
      set: (value)->
        check value, checkPattern
        @[privatePropName] = value

  @typedProperties: (propNames, checkPattern) =>
    @typedProperty n, checkPattern for n in propNames

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
      ret[pnew] = @[p]
    ret

  ###
  This function initializes DataType object from the "dumb" object - the same as the one returned by
  __getData()
  It's simpler than __getData() since we have getters / setters with proper names already, so we get
  automatic typechecking as a bonus as well
  ###
  __fromData: (data)->
    @[p] = data[p] for p in Object.getOwnPropertyNames data