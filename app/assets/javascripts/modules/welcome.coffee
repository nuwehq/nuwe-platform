class Landing

  init: ->
    if ($("body").hasClass("welcome") && !$("body").hasClass("signup_page"))
      scrollIntervalID = setInterval(stickMenu, 100)
      do scroll_to
      do tabs
      do slickInit



  slickInit = ->
    $('.slider').slick
      dots: false
      arrows: true
      autoplay: true
      autoplaySpeed: 9000



  tabs = ->
    $(".welcome .group .tab").click ->
      type = $(this).data('type')
      $(".welcome .group .tab").removeClass('active')
      $(this).addClass('active')
      $(".welcome .mail_type").val(": #{type}")

    $(".welcome .contact_form").on("ajax:success", (e, data, status, xhr) ->
      sweetAlert("Thank you!","We will answer soon","success")
      $(".text_area_wrapper textarea").val("")
    ).on "ajax:error", (e, xhr, status, error) ->
      swal("Oops!", "Something went wrong, please try again.", "error")




  stickMenu = ->

    orgElementPos = $('.sticky_menu.original').offset()
    orgElementTop = orgElementPos.top

    if ($(window).scrollTop() >= (orgElementTop))

      orgElement = $('.sticky_menu.original')
      coordsOrgElement = orgElement.offset()
      leftOrgElement = coordsOrgElement.left
      widthOrgElement = orgElement.css('width')
      $('.cloned').css
        'left': "#{leftOrgElement}px"
        'top': 0
        'width': widthOrgElement
      .fadeIn(100)

      $('.sticky_menu.original').css('visibility','hidden')
    else
      $('.sticky_menu.cloned').fadeOut(100)
      $('.sticky_menu.original').css('visibility','visible')



    $('.section').each ->
      if $(window).scrollTop() >= $(@).offset().top-100
        klass = $(@).attr('class').replace(" section", "")
        $('.sticky_menu a').removeClass('active')
        $(".sticky_menu a[href=##{klass}]").addClass('active')


  scroll_to = ->

    $('.sticky_menu a').click (e) ->
      e.preventDefault()
      target = $(@).attr("href").replace(/#/, "")
      $('html, body').animate
          scrollTop: $(".#{target}").offset().top-80
      , 500

    $('.return_to_top_button').click ->
      $('html, body').animate
          scrollTop: 0
      , 500




$(document).ready ->
  window.App.landing = new Landing
  window.App.landing.init()






