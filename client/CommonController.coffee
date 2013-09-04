class @CommonController
  @subs = {}

  @subscribe: (name)->
    @subs[name] = Meteor.subscribe name

  @getSubscription: (name)-> @subs[name]

  @formatDate: (timestamp)->
    timestamp.toDateString()