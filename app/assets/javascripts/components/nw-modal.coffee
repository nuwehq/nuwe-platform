class NwModal
  events = []
  init: ->
    $('.nw-modal .nw-close').click (event) =>
      $(event.target).closest('.nw-modal').removeClass('showed')
      @fire 'close'

    $('.nw-modal-trigger').click ->
      modal = $(this).data('modal-name')
      $('.nw-modal').each (i,e) ->
        if $(e).data('modal-name') is modal
          $(e).addClass('showed')


  show: (name) =>
    $('.nw-modal').each (i,e) ->
      if $(e).data('modal-name') is name
        $(e).addClass('showed')
    @fire 'show'

  hide: =>
    $('.nw-modal').removeClass('showed')
    @fire 'close'



  on: (event, callback) =>
    events.push {
      "#{event}": callback
    }

  off: (event) =>
    events = _.filter events, (el) -> !el.hasOwnProperty("#{event}")

  fire: (event) =>
    try
      for e in events
        do e[event]
    catch
      console.error 'Event handler undefined'







$(document).ready ->
  window.App.nwModal = new NwModal
  window.App.nwModal.init()









