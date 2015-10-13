Template._post.rendered = ->
  $('pre code').each (i,e)-> hljs.highlightBlock e
  e = new Error
  console.log e.stack
