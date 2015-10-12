Template.disqus.rendered = ->
  ###
  # We don't want to load Disqus until the first time the template is
  # rendered, since it requires the #disqus_thread div
  # Triggers Deps.autorun (below)
  ###
  Session.set("loadDisqus", true)

  ###
  # OPTIONAL: Only include the part below if you're using
  # Disqus single-sign on
  # Generate the disqusSignon variable appropriately from your server
  ###
  ###
  disqusSignon = Session.get("disqusSignon")
  if Meteor.user() and disqusSignon
    window.disqus_config = ->
      this.page.remote_auth_s3 = "#{disqusSignon.auth}"
      this.page.api_key = "#{disqusSignon.pubKey}"
    # ... other Disqus configs

  ###
  DISQUS?.reset(
    reload: true
    config: ->
  )

  Tracker.autorun(->
    # Load the Disqus embed.js the first time the `disqus` template is rendered
    # but never more than once
    if Session.get("loadDisqus") && !window.DISQUS
      #console.log 'running disqus thingy'
      # Below is the Disqus Universal Code
      # * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * *
      disqus_shortname = 'superstringsoftware' #"meteorology" # required: replace example with your forum shortname

    # * * DON'T EDIT BELOW THIS LINE * *
      (->
        #console.log "inside the main callback"
        dsq = document.createElement("script")
        dsq.type = "text/javascript"
        dsq.async = true
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js"
        (document.getElementsByTagName("head")[0] or document.getElementsByTagName("body")[0]).appendChild dsq
      )()
  )