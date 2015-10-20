Template._featuredPost.onRendered ->

  opts =
    lines: 13
    length: 28
    width: 8
    radius: 20
    scale: 1
    corners: 1
    color: '#000'
    opacity: 0.25
    rotate: 0
    direction: 1
    speed: 1
    trail: 60
    fps: 20
    zIndex: 2e9
    className: 'spinner'
    top: '80%'
    left: '50%'
    shadow: true
    hwaccel: true
    position: 'relative'
  target = document.getElementById('spinner')
  spinner = new Spinner(opts).spin(target)

  Tracker.autorun (c)->
    if LastPosts.subscription.ready()
      c.stop()
      spinner.stop() 