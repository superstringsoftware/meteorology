class @MainPageController extends RouteController
  template: 'main'

  renderTemplates:
    'sidebar': to: 'sidebar'
    'footer': to: 'footer'

  data: ->
    ret =
      title: 'Hello World'
      text: "Lorem ipsum dolor sit amet, <b>consectetur adipiscing elit</b>. Cras sodales, augue ut sodales pellentesque, erat est placerat diam, id hendrerit odio urna a nunc. Ut nec nunc quis sapien viverra dictum. Integer lacinia sollicitudin lacinia. Nullam fermentum magna in magna tincidunt, ut consequat mauris placerat. Pellentesque quis ultricies velit. Donec vitae varius odio."

    ret

  run: ->
    console.log 'running'
    super

Template.main.created = ->


Template.main.rendered = ->
