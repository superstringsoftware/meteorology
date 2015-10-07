tb = Observatory.getToolbox()

# @Posts - universal posts collection, defined in common code
# @LastPosts - only last posts, available universally
@LastPosts = new TypedCollection 'lastPosts', Post
LastPosts.subscribe 'lastPosts'