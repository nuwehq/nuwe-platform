class NwSegmented

  init: ->
    $('.nw-segmented .btn').click ->

      $('.nw-segmented .btn:has(input:checked)').addClass('active')
      $('.nw-segmented .btn:has(input:not(:checked))').removeClass('active')





$(document).ready ->
  window.App.nwSegmented = new NwSegmented
  # window.App.nwSegmented.init()









