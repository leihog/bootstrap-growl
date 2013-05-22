# https://github.com/ifightcrime/bootstrap-growl

$ = jQuery

$.bootstrapGrowl = (message, options) ->
  options = $.extend({}, $.bootstrapGrowl.default_options, options)

  setTimeout = (t,f) ->
      window.setTimeout f, t

  $alert = $("<div>")
  $alert.attr "class", "bootstrap-growl alert"
  $alert.addClass "alert-" + options.type if options.type
  $alert.append "<a class=\"close\" data-dismiss=\"alert\" href=\"#\">&times;</a>" if options.allow_dismiss
  $alert.append message

  # Prevent BC breaks
  if options.top_offset
    options.offset =
      from: "top"
      amount: options.top_offset

  # calculate any 'stack-up'
  offsetAmount = options.offset.amount
  $(".bootstrap-growl").each ->
    offsetAmount = Math.max(offsetAmount, parseInt($(this).css(options.offset.from)) + $(this).outerHeight() + options.stackup_spacing)

  css =
    "position": (if options.ele is "body" then "fixed" else "absolute")
    "margin": 0
    "z-index": "9999"
    "display": "none"

  css[options.offset.from] = offsetAmount + "px"

  $alert.css css

  $alert.css "width", options.width + "px" if options.width isnt "auto"

  # have to append before we can use outerWidth()
  $(options.ele).append $alert

  switch options.align
    when "center"
      $alert.css
        "left": "50%"
        "margin-left": "-#{$alert.outerWidth() / 2}px"
    when "left"
      $alert.css "left", "20px"
    else
      $alert.css "right", "20px"

  if options.url
    $alert.on "click", (e) ->
      return if $(e.target).is "a"
      window.location = options.url
      return

  $alert.fadeIn()

  # Only remove after delay if delay is more than 0
  if options.delay > 0

    $(options.ele).on "mouseenter", ".bootstrap-growl.alert", ->
      to = $(this).data 'bootstrap-growl-to'
      if to
        $(this).data 'bootstrap-growl-to', false
        clearTimeout to if to

    $(options.ele).on "mouseleave", ".bootstrap-growl.alert", ->
      to = $(this).data 'bootstrap-growl-to'
      if to?
        closeAlert.call this unless to

    closeAlert = ->
      $(this).data 'bootstrap-growl-to', setTimeout options.delay, =>
          $(this).fadeOut =>
            $(this).alert "close"

    closeAlert.call($alert)

  $alert

$.bootstrapGrowl.default_options =
  ele: "body"
  type: null
  offset:
    from: "top"
    amount: 20
  align: "right" # (left, right, or center)
  width: 250
  delay: 4000
  allow_dismiss: true
  stackup_spacing: 10

