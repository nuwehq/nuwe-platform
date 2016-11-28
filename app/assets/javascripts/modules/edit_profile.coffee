class EditProfile

  init: ->

    $(".technologies input").tagit
      availableTags: window.technologies
      caseSensitive: false
      'placeholderText':'Add more'

    $('.profile form [type=submit]').click ->
      NProgress.start()

    $('.profile form').on "ajax:complete", (e, data, status, error) ->
      NProgress.done()

      console.log data.responseText

      if (""+data.status == "200" || ""+data.status == "201")
        swal("Updated", "", "success")
        if data.responseText.indexOf('avatars') != -1
          $('.big_image img').attr('src', data.responseText).css('opacity','1')
          $('.nw-login .avatar img').attr('src', data.responseText).css('opacity','1')

          console.log
      else
        swal("Oops!", "Something went wrong, please try again.", "error")

    $('.profile .file_input_wrapper input').on 'change', (evt) ->
      tgt = evt.target || window.event.srcElement
      files = tgt.files
      if (FileReader && files && files.length)
        fr = new FileReader()
        fr.onload = ->
          $('.big_image img').attr('src', fr.result).css('opacity','0.5')

        fr.readAsDataURL(files[0])

      else
        console.log "FileReader not supported"










$(document).ready ->
  window.App.editProfile = new EditProfile
  window.App.editProfile.init()









