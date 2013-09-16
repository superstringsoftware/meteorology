Template.google.rendered = ->
	if !window._gaq?
  	window._gaq = []
  	_gaq.push(['_setAccount', 'UA-35612067-3'])
  	_gaq.push(['_trackPageview'])

	(->
  	ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  	gajs = '.google-analytics.com/ga.js'
  	ga.src = if 'https:' is document.location.protocol then 'https://ssl'+gajs else 'http://www'+gajs
  	s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s)
	)()
	
###
  <script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-35612067-3', 'meteorology.io');
  ga('send', 'pageview');

</script>
###