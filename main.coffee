tl = TLog.getLogger()
@Posts = new Meteor.Collection 'posts'
@allowAdmin = (uid)-> if Meteor.users.findOne(uid)?.securityProfile?.globalRole is "admin" then true else false

if Meteor.isServer
  au = Meteor.users.find({"securityProfile.globalRole": "admin"}).count()

  Posts.allow
    insert: allowAdmin
    update: allowAdmin
    remove: allowAdmin


  tl.info "Found " + au + " admin users"
  # accounts setup for initial admin user
  # removal rights on the logs
  TLog.allowRemove allowAdmin
  if au < 1
    tl.warn("No admin users found, creating default...")
    try
      id = Accounts.createUser
        username: "admin"
        email: "jho.xray@gmail.com"
        password: "password"
        securityProfile:
          globalRole: "admin"
        profile:
          firstName: "Jay"
          lastName: "Ho"
      tl.info("Admin user created with id: " + id)
    catch err
      tl.error("Admin account creation failed with error " + err.name + ", message: " + err.message + "<br/>\n" + err.stack)

  # Publishing
  Meteor.publish 'allPosts',->
    tl.debug "Publishing All Posts for user #{@userId}"
    Posts.find()

  # publishing roles
  Meteor.publish "userData", ->
    tl.debug "Publishing user info for user #{@userId}"
    Meteor.users.find {_id: @userId}, {fields: {securityProfile: 1}}



  # if no posts exist, add some.
  if Posts.find().count() is 0

    posts = [
      title: "Meteor Source Maps have arrived!"
      tagline: "...and you will love it"
      body: [
        content: "You can now map to your CoffeScript source files from the browser."
        type: "text"
      ,
        content: "Aint't it cool?"
        type: "text"
      ]
    ,
      title: "Bootstrap 3 Goes Mobile First!"
      tagline: "testing preformatted text"
      body: [
        content: "With Bootstrap 3, <p>mobile devices</p> will load <i>only</i> necessary Styles and Content."
        type: "html"
      ,
        content: """
                 Some preformatted markdown!
                 ---------------------------

                 This is how we roll:
                  * one
                  * two
                  * three
                 """
        type: "markdown"
      ,
        content: """
                 class Horse extends Animal
                 constructor: ->
                   @name = 'Sunny'
                   super
                 """
        type: "coffeescript"
      ]

    ]



    for postData in posts
      Posts.insert
        title: postData.title
        tagline: postData.tagline
        body: postData.body
        createdAt: new Date




if Meteor.isClient
  Router.configure
    layout: "layout"
    notFoundTemplate: "notFound"
    loadingTemplate: "loading"

  CommonController.subscribe 'allPosts'
  CommonController.subscribe 'userData'

  Session.set 'codemirrorTypes', ['htmlmixed','markdown','javascript','coffeescript','css','xml']

  Handlebars.registerHelper "getSession", (name)-> Session.get name
