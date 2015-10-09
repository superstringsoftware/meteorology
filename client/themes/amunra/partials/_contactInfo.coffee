tb = Observatory.getToolbox()

Template._contactInfo.onRendered ->
  $("#_sent_ok_").hide()


Template._contactInfo.events
  'click #contact_submit': (evt, tmpl)->
    #console.log "Submitting message"
    message =
      name: $("#contact_name").val()
      email: $("#contact_email").val()
      subj: $("#contact_subject").val()
      msg: $("#contact_comment").val()

    #console.log message

    $("#contact_name").val('')
    $("#contact_email").val('')
    $("#contact_subject").val('')
    $("#contact_comment").val('')

    tb._info "Received new message", message, "Visitor.Message"
    $("#_sent_ok_").show()

