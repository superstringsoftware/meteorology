###
  Syntactic shugar so that we can do this:
  class Name
    constructor: (@first, @last) ->
    @property 'name',
      get: -> "#{@first} #{@last}"
      set: (name)-> [@first, @last] = name.split ' '
###
Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

###
  Even better syntactic shugar:
  class Name
    @typedProperty "name", String - that's it!!
  check - is meteor add check, checks for a pattern and throws an exception if it's not passed
###

Function::typedProperty = (propName, checkPattern) ->
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

###
  Same as above but for array of property names - convenient if need to define a number of string properties for instance
###

Function::typedProperties = (propNames, checkPattern) ->
  @typedProperty n, checkPattern for n in propNames
