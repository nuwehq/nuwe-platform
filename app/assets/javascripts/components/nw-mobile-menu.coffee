class NwMobileMenu

  init: ->
    $(".nw-mobile-navbar").mmenu
      offCanvas:
        position: "right"

    $(".show_nw-mobile-navbar").click ->
      $(".nw-mobile-navbar").trigger("open.mm")








$(document).ready ->
  window.App.nwMobileMenu = new NwMobileMenu
  window.App.nwMobileMenu.init()









