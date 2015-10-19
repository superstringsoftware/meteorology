Template.registerHelper "lastPost", ->
  LastPosts.findOne({}, sort: createdAt: -1)