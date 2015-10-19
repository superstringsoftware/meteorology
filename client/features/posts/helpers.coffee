Template.registerHelper "lastPost", ->
  LastPosts.findOne({}, sort: createdAt: -1)

Template.registerHelper "remainingPosts", ->
  Posts.find({}, {sort: {createdAt: -1}, skip: 1}).fetch()