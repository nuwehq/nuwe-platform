class EditApp

  init: ->
    do launchTabSwitcher
    do copyHandler
    do filter
    do capabilitiesModal
    do handleDataTable
    do handleParseView
    do handleGeneralView

    $('.general form [type=submit]').click ->
      NProgress.start()

    $('.general form').on "ajax:complete", (e, data, status, error) ->
      NProgress.done()
      if (""+data.status == "200" || ""+data.status == "201")
        if data.responseText.indexOf('icons') != -1
          $('.app_big_image img').attr('src', data.responseText).css('opacity','1')
      else
        swal("Oops!", "Something went wrong, please try again.", "error")

    $('.general .file_input_wrapper input').on 'change', (evt) ->
      tgt = evt.target || window.event.srcElement
      files = tgt.files
      if (FileReader && files && files.length)
        fr = new FileReader()
        fr.onload = ->
          $('.app_big_image img').attr('src', fr.result).css('opacity','0.5')

        fr.readAsDataURL(files[0])

      else
        console.log "FileReader not supported"

  loadDeviceTable: (url, type) ->
    $('.nw-data-table .loader').addClass('visible')
    $.ajax
      url: url,
      type: "GET",
      contentType: "application/json",
      dataType: "json"
    .done (data) ->
      window.data = data
      rows = []
      cols = []


      if data[type]?.length
        for record in data[type]
          row = record.data[0] || record.data
          row.id = record.id
          row.created_at = record.created_at || row.created_at
          row.updated_at = record.updated_at || row.updated_at
          rows.push row


      if data.meta?.columns?.length
        for column in data.meta.columns
          cols.push
            _id: column.id
            id: column.field_name
            name: "#{column.field_name} <span>#{column.type}</span>"
            field: column.field_name
            minWidth: column.width || 150
            editor:  if column.read_only then null else column.editor
            sortable: true
            type: column.type
            readonly: column.read_only
            editor_name: column.editor
            visible: column.visible
      window.App.nwDeviceTable.init '.nw-data-table',
        rows,
        cols,
        {
          url: url,
          type: type
        }

  loadParseTable: (url, type) ->
    $('.nw-data-table .loader').addClass('visible')
    $.ajax
      url: url,
      type: "GET",
      contentType: "application/json",
      dataType: "json",
    .done (data) ->
      window.data = data
      rows = []
      cols = []


      if data[type]?.length
        for record in data[type]
          row = record
          row.id = record['objectId']
          rows.push row

      className = data.meta?.classes || ''
      columns = null

      for schema in data.schemas.results
        if schema.className is className
          columns = schema.fields

      if columns
        for name, column of columns
          if name != 'ACL' && name != 'id' && name != 'created_at' && name != 'updated_at'
            cols.push
              _id: name
              id: name
              name: "#{name} <span>#{column.type}</span>"
              field: name
              minWidth: 150
              editor:  if name is 'objectId' then null else column.type
              sortable: true
              type: column.type
              readonly: name is 'objectId'
              editor_name: column.type
              visible: true

      window.App.nwParseTable.init '.nw-data-table',
        rows,
        cols,
        {
          url: url,
          type: type,
          meta: data.meta.parse_app,
          className: className
        }









  loadReadonlyTable: (url, type) ->
    $('.nw-data-table .loader').addClass('visible')
    $.ajax
      url: url,
      type: "GET",
      contentType: "application/json",
      dataType: "json",
      success: (data) ->
        window.data = data
        for type, results of data
          columns = []
          table_data = []
          if results.length
            for key,val of results[0]
              type = ''
              switch key
                when "date" then type = "date"
                when "created_at" then type = "datetime"
                when "timestamp" then type = "datetime"
                when "updated_at" then type = "datetime"
                else type = "string"

              columns.push
                id: key
                name: key
                field: key
                minWidth: 150
                editor: null
                sortable: true
                type: type

            for result in results
              result.id = result.id || "#{Math.floor(Math.random()*1000000)}000"
              table_data.push result

          window.App.nwReadonlyTable.init '.nw-data-table',
            table_data,
            columns,
            {
              url: url,
              type: type
            }








  hashChecker = ->
    if window.location.hash.length
      hash_array = location.hash.slice(1).split('/')
      hash = hash_array.shift()
      if !!$(".tab_switcher li a.switch-#{hash}").length and !!$(".tabs_to_switch .#{hash}").length
        $(".tab_switcher li a").removeClass("active")
        $('.tabs_to_switch .tab').hide().removeClass('active_tab')
        $(".tab_switcher li a.switch-#{hash}").addClass('active')
        $(".tabs_to_switch .#{hash}").show().addClass('active_tab')
      else
        $(".tab_switcher li a.switch-general").addClass('active')
        $(".tabs_to_switch .general").show().addClass('active_tab')

      console.log(hash)
      switch hash
        when 'data'
          switch hash_array.length
            when 1
              [nav_hash] = hash_array
              handleDataMenuItemClick $(".#{nav_hash} .data_menu__item_label a")
            when 2
              [nav_hash, subnav_hash] = hash_array
              handleDataSubMenuItemClick $(".#{nav_hash} .id-#{subnav_hash}")
            when 3
              [nav_hash, subnav_hash, App.table_hash] = hash_array
              handleDataSubMenuItemClick $(".#{nav_hash} .id-#{subnav_hash}")

        when 'general'
          [nav_hash] = hash_array
          console.log nav_hash
          if !!nav_hash
            handleGeneralMenuItemClick $(".#{nav_hash} .general_menu__item_label a")
          else
            handleGeneralMenuItemClick $(".settings .general_menu__item_label a")

        when 'parse'
          [nav_hash] = hash_array
          if !!nav_hash
            handleParseMenuItemClick $(".#{nav_hash} .parse_menu__item_label a")
          else
            handleParseMenuItemClick $(".settings .parse_menu__item_label a")



    else
      # if !!$(".tab_switcher li a.switch-#{hash}").length and !!$(".tabs_to_switch .#{hash}").length
      $('.tabs_to_switch .tab').hide().removeClass('active_tab')
      $(".tab_switcher li a").first().addClass("active")
      $(".tabs_to_switch .tab").first().show().addClass('active_tab')
      handleGeneralMenuItemClick $(".settings .general_menu__item_label a")


    if ($('.tab_switcher .active').hasClass('switch-data') || $('.tab_switcher .active').hasClass('switch-parse') || $('.tab_switcher .active').hasClass('switch-general'))
      $('.edit_app_content').addClass('fullwidth')
    else
      $('.edit_app_content').removeClass('fullwidth')


  launchTabSwitcher = ->
    do hashChecker


    $('a.app-edit-nav').click (event) ->
      $(window).one 'hashchange', ->
        do hashChecker


    $(".tab_switcher li a").click (e) ->
      if $('.tabs_to_switch').length
        e.preventDefault()
        window.location.hash = "##{$(this).attr('href').split('#').slice(-1)}"

      $(".tab_switcher li a").removeClass("active")
      index = $(this).addClass("active").parent().index()
      $('.tabs_to_switch .tab').hide().removeClass('active_tab')
      $(".tabs_to_switch .#{$(this).attr('href').split('#').slice(-1)}").show().addClass('active_tab')
      $(".subnav .preview").text $(this).text()

      if $(".subnav .preview").css("display") is "block"
        $(".subnav ul").slideToggle()

      if ($('.tab_switcher .active').hasClass('switch-data') || $('.tab_switcher .active').hasClass('switch-parse') || $('.tab_switcher .active').hasClass('switch-general'))
        $('.edit_app_content').addClass('fullwidth')
        if !$('.tab_switcher .active .menu').find('.active').length
          $('.tabs_to_switch .active_tab .menu').children().first().find('a').click()
      else
        $('.edit_app_content').removeClass('fullwidth')

    $(".subnav .preview").click ->
      $(".subnav ul").slideToggle()


  copyHandler = ->
    $('.keys .copy_key').click ->
      console.log
      if $(this).prev().children().length
        $(this).prev().find('input')[0].setSelectionRange(0, $(this).prev().find('input').val().length)
      else
        $(this).prev()[0].setSelectionRange(0, $(this).prev().val().length)

    new Clipboard('.copy_key')



  filter = ->
    $('.services-filters-filter').click ->
      type = $(this).data('type')

      $(this).toggleClass('disabled')

      $(".nw-service-list .service[data-type=#{type}]").fadeToggle()


  capabilitiesModal = ->
    $('.applications .services .service').click (event) ->
      target = event.target.nodeName
      unless (("#{target}" is "A") or ("#{target}" is "INPUT") or ("#{target}" is "I") or ("#{target}" is "LABEL"))

        if $(this).hasClass('service-name-cubitic')
          unless (/mobile|tablet/i.test(navigator.userAgent.toLowerCase()))
            App.nwModal.show 'cubitic'
            $('.nw-modal .nw-close').click ->
              $(this).closest('.nw-modal').removeClass('showed')

        else
          url = $(this).find('a.credentials').attr('href')
          $.ajax
            url: "#{url}",
            success: (data) ->
              $('.nw-modal.capabilities .nw-modal-content').html(data)
              App.nwModal.show 'capabilities'
              $('.nw-modal .nw-close, .nw-modal .nw-modal-overlay').click ->
                $(this).closest('.nw-modal').removeClass('showed')




  handleDataTable = ->
    $('.data_menu__item a').click (event) ->
      event.preventDefault()
      event.stopPropagation()
      if $(this).parent().hasClass('data_menu__item_label')
        unless $(this).parent().parent().hasClass('active')
          handleDataMenuItemClick(this)
      else
        unless $(this).parent().hasClass('active')
          handleDataSubMenuItemClick(this)

  handleDataMenuItemClick = (item) ->
    $('.data_menu__item').removeClass('active')
    $('.data_submenu__item').removeClass('active')
    $item = $(item)
    type = $item.closest('.data_menu__item').addClass('active').data('type')
    hash = window.location.hash.slice(1).split('/')[0]
    if $item.attr('href') is "#"
      handleDataSubMenuItemClick $item.closest('.data_menu__item').find('.data_submenu a').first()
    else
      App.editApp.loadReadonlyTable($item.attr('href'), type)
      window.location.hash = hash + '/' + type


  handleDataSubMenuItemClick = (item) ->
    $('.data_menu__item').removeClass('active')
    $('.data_submenu__item').removeClass('active')
    $item = $(item)
    hash = window.location.hash.slice(1).split('/')[0]
    type = $item.closest('.data_menu__item').addClass('active').data('type')
    id = $item.data('id')
    $item.parent().addClass('active')

    switch type
      when 'device_results' then App.editApp.loadDeviceTable($item.attr('href'), type)
      when 'parse' then App.editApp.loadParseTable($item.attr('href'), type)
      else App.editApp.loadReadonlyTable($item.attr('href'), type)

    window.location.hash = hash + '/' + type + '/' + id


  handleGeneralView = ->
    $('.general_menu__item a').click (event) ->
      if $(this).parent().hasClass('general_menu__item_label')
        unless $(this).parent().parent().hasClass('active')
          handleGeneralMenuItemClick(this)



  handleGeneralMenuItemClick = (item) ->
    $('.general_menu__item').removeClass('active')
    $('.general_submenu__item').removeClass('active')
    $item = $(item)
    type = $item.closest('.general_menu__item').addClass('active').data('type')
    $(".general_view .general_view_tab").hide()
    $(".general_view .#{type}").show()


  handleParseView = ->
    $('.parse_menu__item a').click (event) ->
      if $(this).parent().hasClass('parse_menu__item_label')
        unless $(this).parent().parent().hasClass('active')
          handleParseMenuItemClick(this)

    $('.parse_view .buttons .save').click (event) ->
      do submit


  handleParseMenuItemClick = (item) ->
    $('.parse_menu__item').removeClass('active')
    $('.parse_submenu__item').removeClass('active')
    $item = $(item)
    type = $item.closest('.parse_menu__item').addClass('active').data('type')
    $(".parse_view .parse_view_tab").hide()
    $(".parse_view .#{type}").show()

    if type is 'cloud_code'
      do launchCodeMirror

  editor = {}
  launchCodeMirror = ->

    value = $('.cloudCodeFileSource').html() || "Hello World!"
    editor = CodeMirror($('.codeEditor')[0],
      value: value
      lineNumbers: true
      mode: 'javascript'
      keyMap: 'sublime'
      autoCloseBrackets: true
      matchBrackets: true
      showCursorWhenSelecting: true
      theme: 'monokai'
      tabSize: 2)


  submit = ->
    s = editor.getDoc().getValue()
    filename = 'cloudcode.js'

    form = $('#apns_upload form')
    formData = new FormData(form[0])
    formData.set('doorkeeper_application[cloud_code_file]', new File([new Blob([s])], filename))
    console.log 'NProgress'
    NProgress.start()

    $.ajax
      url: form.attr('action'),
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      data: formData,
      processData: false,
      contentType: false,
      type: 'POST',
      success: ->
        console.log('ok')
        NProgress.done()

      error: ->
        console.log('err')
        NProgress.done()





$(document).ready ->
  window.App.editApp = new EditApp
  window.App.editApp.init()




