Template._timestampEditor.events
  'click #btnUpdateTimestamp': (e)->
    ts = Template.currentData()
    d = $("#input_date").val()
    m = $("#input_month").val()
    y = $("#input_year").val()
    ts.setFullYear y
    ts.setMonth m
    ts.setDate d
