class CreateNewApp

  controller_url = null
  app_id = null


  init: ->

    controller_url = $("form.create_app_with_name").attr("action")


    $('form.create_app_with_name').on("ajax:success", (evt, data, status, xhr) ->
      go_to_second_step(evt, data, status, xhr)
    ).on "ajax:error", (e, xhr, status, error) ->
      swal("Oops!", "Something went wrong, please try again.", "error")

    $('.go_to_step_3').click ->
      do go_to_third_step



    $('#select_plan').dropdown()

    $('#select_plan').change ->
      $.ajax
        url: "#{controller_url}/#{app_id}",
        type: "PATCH",
        data:
          id: app_id
          platform: $('#select_plan').val()




    $(".service_section_header").click ->
      $(this).toggleClass("opened").parent().find(".service_section_body").slideToggle()


    # $('.sdk_item').click ->
    #   App.nwModal.show 'congratulations'
    #   App.nwModal.on 'close', ->
    #     window.location.href = '/oauth/applications'


  go_to_second_step = (evt, data, status, xhr) ->
    # we can put data.app_id to select params, for example
    data = data.slice(1)
    data = data.substring(0, data.length - 1)
    data = data.split(",")
    app_id = data[0]
    data = data.slice(1)

    $(".nw-switch input[name=application_id]").val(app_id)
    $("a.credentials").each (i,e) ->
      href = $(e).attr("href")
      $(e).attr("href", href+"?application_id=#{app_id}")
      $(e).attr("target", "_blank")

    for service_id in data
      $(".nw-switch #service_#{service_id.slice(1)}_enabled").prop( "checked", true )



    $(".circle").css("left", "35px")
    $(".toggler").css("background", "#88D68F")
    $(".progressbar").attr('data-step','2')
    $(".name_your_app").delay(500).fadeOut 300, ->
      $(".connect_services").fadeIn()

  go_to_third_step = ->
    $(".progressbar").attr('data-step','3')
    $(".connect_services").fadeOut 300, ->
      $(".install_sdk").fadeIn ->
        App.nwModal.show 'congratulations'
        App.nwModal.on 'close', ->
          window.location.href = '/oauth/applications'



$(document).ready ->
  window.App.createNewApp = new CreateNewApp
  window.App.createNewApp.init()
