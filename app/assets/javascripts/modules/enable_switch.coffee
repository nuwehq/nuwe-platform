$(document).ready ->
  $('.toggle_application').click ->
    unless $(this).hasClass('passive')
      $(this).closest('form').submit()