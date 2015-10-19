Template._post.onRendered ->
  $('pre code').each (i,e)-> hljs.highlightBlock e

Template._featuredPost.onRendered ->
  $('pre code').each (i,e)-> hljs.highlightBlock e
