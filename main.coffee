tl = Observatory.getToolbox()

#@Posts = new PostsEntity()
@Posts = new TypedCollection 'posts', Post

if Meteor.isServer

  #console.dir Meteor.default_server?.stream_server?.open_sockets
  #console.dir Meteor.server

  au = Meteor.users.find({"securityProfile.globalRole": "admin"}).count()
  #Observatory.meteorServer.publish -> true
  Observatory.emitters.Monitor.startMonitor(300000)

  tl.info "Found " + au + " admin users"
  # accounts setup for initial admin user
  # removal rights on the logs
  # TLog.allowRemove allowAdmin
  if au < 1
    tl.warn("No admin users found, creating default...")
    try
      id = Accounts.createUser
        username: "admin"
        email: "jho.xray@gmail.com"
        password: "password"
        authProfile:
          globalRole: "admin"
        profile:
          firstName: "Jay"
          lastName: "Ho"
      tl.info("Admin user created with id: " + id)
      Meteor.users.update id,
        $set:
          securityProfile:
            globalRole: "admin"
    catch err
      tl.error("Admin account creation failed with error " + err.name + ", message: " + err.message + "<br/>\n" + err.stack)

  # publishing roles
  Meteor.publish "userData", ->
    tl.debug "Publishing user info for user #{@userId}"
    Meteor.users.find {_id: @userId}, {fields: {securityProfile: 1}}

  # if no posts exist, add some.
  ###
  if Posts.find().count() is 0

    posts = [
      title: "Meteor Source Maps have arrived!"
      tagline: "...and you will love it"
      body: "You can now map to your CoffeScript source files from the browser."
    ,
      title: "Bootstrap 3 Goes Mobile First!"
      tagline: "testing preformatted text"
      body: """
                 Some preformatted markdown!
                 ---------------------------

                 This is how we roll:
                  * one
                  * two
                  * three
            """
    ]



    for postData in posts
      Posts.insert
        title: postData.title
        tagline: postData.tagline
        body: postData.body
        createdAt: new Date

  ###

  #console.dir Meteor.server

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



