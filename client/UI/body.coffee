# making Amunra js work -- FIXME: need a MUCH better way!!!
Template.main.onRendered ->
  Tracker.afterFlush ->
    Core()
    if $().parallax

      $('.parallax.parallax-default').css 'background-attachment', 'fixed'
      $('.parallax.parallax-default').parallax '50%', '0.4'
      $('.parallax.parallax-1').css 'background-attachment', 'fixed'
      $('.parallax.parallax-1').parallax '50%', '0.4'
      $('.parallax.parallax-2').css 'background-attachment', 'fixed'
      $('.parallax.parallax-2').parallax '50%', '0.4'
      $('.parallax.parallax-3').css 'background-attachment', 'fixed'
      $('.parallax.parallax-3').parallax '50%', '0.4'
      $('.parallax.parallax-4').css 'background-attachment', 'fixed'
      $('.parallax.parallax-4').parallax '50%', '0.4'

      ### Home Slider ###

      $('#home div.slider').css 'background-attachment', 'fixed'
      $('#home div.slider').parallax '50%', '0.4'

