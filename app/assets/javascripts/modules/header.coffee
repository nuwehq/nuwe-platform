class Header

  state: 'signup'

  init: =>
    $(".show_login").click (event) ->
      event.preventDefault()
      $(".nw-mobile-navbar").trigger("close.mm")
      open_login()

    if window.location.hash is "#signup"
      context = $(".signup_evangelist")
      open_signup(context)

    if $('body').hasClass('signup_page')
      context = $(".signup_evangelist")
      open_signup($('body'))

    $(".signup, .mobile_signup, .signup_evangelist, .plus").click ->
      $(".nw-mobile-navbar").trigger("close.mm")
      open_signup(this)

    $('.toggle_state').click =>
      if @state is 'signup'
        $('.toggle_state .sign_up').toggle()
        $('.toggle_state .login').toggle()
        open_login()

        @state = 'login'
      else if @state is 'login'
        $('.toggle_state .sign_up').toggle()
        $('.toggle_state .login').toggle()
        open_signup($('body'))
        @state = 'signup'


    $(".close").click ->
      close_dropdown()

    $(".show_menu").click ->
      $(".mobile_menu").slideToggle()
      $(window).on 'resize', ->
        $(".mobile_menu").slideUp()
        $(window).off 'resize'




    $(".do_login").click (event) ->
      event.preventDefault()
      unless $(this).closest("form").hasClass("error")
        $(this).closest("form").submit()




    $(".signup_button").click (event) ->
      event.preventDefault()
      unless $(this).closest("form").hasClass("error")
        $(this).closest("form").submit()




    $(".appname").on "keyup", ->

      if $(this).val()
        $("h3.app_name").text($(this).val())
      else
        $("h3.app_name").text("Your app name")




    $(".login_form").on("ajax:success", (e, data, status, xhr) ->
      window.location.href = data
    ).on "ajax:error", (e, xhr, status, error) ->
      if error is "Unprocessable Entity"
        swal("Wrong login or password", null, "error")
      else
        swal("Oops!", "Something went wrong, please try again.", "error")


    $(".new_user").on("ajax:success", (e, data, status, xhr) ->
      window.location.href = '/first_app'
    ).on "ajax:error", (e, xhr, status, error) ->
      if error is "Unprocessable Entity"
        errorText = ''
        _.forEach xhr.responseJSON.errors, (value, key) =>
          errorText += "#{key} #{value} "

        swal("Oops!", errorText, "error")
      else
        swal("Oops!", "Something went wrong, please try again.", "error")


  open_login = ->

      $(".dropdown_panel .container").addClass("login_view")
      if $(".first_step, .second_step").hasClass("visible")
        $(".first_step, .second_step").removeClass("visible").bind 'transitionend', =>
          $(".login").addClass("visible")
          $(".first_step, .second_step").unbind 'transitionend'
      else
        $(".login").addClass("visible")
      $(".header").css('z-index', '501').addClass("dropped")

  open_signup = (context) ->
    if $(context).hasClass('signup_evangelist')
      $(".become_evangelist").addClass("visible")
      $(".dropdown_panel .container").addClass("evangelists_view")

    else
      $(".dropdown_panel .container").removeClass("login_view")
      if $(".login, .second_step").hasClass("visible")
        $(".login, .second_step").removeClass("visible").bind 'transitionend', ->
          $(".first_step").addClass("visible")
          $(".login, .second_step").unbind 'transitionend'
      else
        $(".first_step").addClass("visible")
    $(".header").css('z-index', '501').addClass("dropped")




  close_dropdown = ->
    $(".header").css('z-index','100').removeClass("dropped").bind 'transitionend', ->
      $(".dropdown_panel .container").removeClass("login_view")
      $(".login, .first_step, .second_step").removeClass("visible")
      $(".header").unbind 'transitionend'


  close_mobile_menu: ->
    $(".mobile_menu").slideUp()



$(document).ready ->
  window.App.header = new Header
  window.App.header.init()









