class NwDataTable
  grid: null

  data: []

  dataView: null

  columns: []

  commandQueue: []

  page: 1
  isAllDataFetched: false

  url: ''
  raw_cols: null
  raw_row: null
  type: ''
  params: {}


  afterInit: =>

    @container.find('.footer .cols, .footer .rows').show()
    @checkIfZeroData()

  options:
    enableCellNavigation: true
    enableColumnReorder:  true
    rowHeight:            40
    editable:             true
    enableAddRow:         false
    asyncEditorLoading:   false
    autoEdit:             false
    checkboxes:           true
    multiColumnSort:      true
    editCommandHandler:   @queueAndExecuteCommand



  checkColumns: (columns) =>
    cols = columns
    visible_cols = []
    created_at = false
    updated_at = false
    for column in cols
      if column.field is 'created_at' then created_at = true

      if column.field is 'updated_at' then updated_at = true

      if column.field is 'createdAt'
        created_at = true
        column.editor = false

      if column.field is 'updatedAt'
        updated_at = true
        column.editor = false
      if column.field is 'objectId'
        column.editor = false


      column.editor = @setEditorByType(column.type)

      if column.type?
        switch column.type.toLowerCase()
          when 'date'
            column.formatter = (row, cell, value, columnDef, dataContext) ->
              if value?
                return moment(new Date(value)).format('ll')
              else
                return value

          when 'datetime'
            column.formatter = (row, cell, value, columnDef, dataContext) ->
              if value?
                return moment(new Date(value)).format('lll')
              else
                return value

      if column.readonly then column.editor = false

      if column.visible then visible_cols.push(column)




    unless created_at
      visible_cols.push
        _id: 999
        id: "created_at"
        name: "created_at <span>datetime</span>"
        field: "created_at"
        type: "datetime"
        editor: false
        readonly: true
        sortable: true
        minWidth: 150
        visible: true
        formatter: (row, cell, value, columnDef, dataContext) ->
          if value?
            return moment(new Date(value)).format('lll')
          else
            return value


    unless updated_at
      visible_cols.push
        _id: 998
        id: "updated_at"
        name: "updated_at <span>datetime</span>"
        field: "updated_at"
        type: "datetime"
        editor: false
        readonly: true
        sortable: true
        minWidth: 150
        visible: true
        formatter: (row, cell, value, columnDef, dataContext) ->
          if value?
            return moment(new Date(value)).format('lll')
          else
            return value


    return visible_cols


  init: (container, data, columns, params) =>
    @raw_cols = _.clone(columns, true)
    columns = @checkColumns(columns)



    {@data, @columns} = {data, columns}

    @url = params.url

    @params = params


    @raw_row = params.raw_row
    @type = params.type
    if $(container).length
      @dataView = new Slick.Data.DataView()

      @container = $(container)


      if @options.checkboxes

        checkboxSelector = new Slick.CheckboxSelectColumn
          cssClass: "slick-cell-checkboxsel"
          forceFitColumns: true

        @columns.unshift checkboxSelector.getColumnDefinition()
        @raw_cols.unshift checkboxSelector.getColumnDefinition()


      @grid = new Slick.Grid @container.find('.table'),
        @dataView,
        @columns,
        @options

      @dataView.setItems @data


      @grid.updateRowCount()
      @grid.render()
      @hideLoader()
      @dataView.getItemMetadata = (index) =>
        item = @dataView.getItem(index)
        if item.isNew is true
          return { cssClasses: 'isnew' }


      if @options.checkboxes
        @grid.setSelectionModel new Slick.RowSelectionModel
          selectActiveRow: false
        @grid.registerPlugin checkboxSelector

      @grid.registerPlugin(new Slick.AutoTooltips())


      do @setEvents

      window.grid = @grid
      window.dataView = @dataView
      @afterInit()

  refresh: =>
    App.editApp.loadDataTable @url

  setEvents: =>

    context = this
    $('.nw-data-table').on 'blur', 'input.editor-text', (event) =>
      unless $(event.target).hasClass('nw-datetimepicker')
        do @hideEditor

    @grid.onSort.subscribe @sort

    @container.find('.slick-column-name').off('click').off('dblclick').click (e) =>
      e.preventDefault()
      e.stopPropagation()
    .dblclick (e) =>
      field = $(e.target).parent().data('column').field || $(e.target).parent().parent().data('column').field
      for column in @columns
        if column.field is field
          unless column.readonly
            @showUpdateColModal(field)

    scrollEnd = (that) =>
      if ($(that)[0].scrollHeight - $(that).scrollTop() == $(that).outerHeight()) and !context.isAllDataFetched
        context.fetchNextPage()

    throttledScrollEnd = _.throttle(scrollEnd, 50)

    @container.find('.slick-viewport').scroll ->
      throttledScrollEnd(this)

    @container.find('.add_col').off('click').click @showNewColModal

    @container.find('.remove_col').off('click').click @showRemoveColModal

    @container.find('.add_row').off('click').click @createRow

    @container.find('.remove_row').off('click').click @deleteRow

    @container.find('.refresh').off('click').click =>
      @refresh()

    @container.find('.display').off('click').click =>
      @showFiltersPopup()

    @grid.onCellChange.subscribe @commitRow

    @dataView.onRowCountChanged.subscribe  (e, args) =>
      @grid.updateRowCount()
      @grid.render()
      @checkIfZeroData()

    @dataView.onRowsChanged.subscribe (e, args) =>
      @grid.invalidateRows(args.rows)
      @grid.render()

    @grid.onSelectedRowsChanged.subscribe =>
      if @grid.getSelectedRows().length
        $('.remove_row').removeClass('disabled')
      else
        $('.remove_row').addClass('disabled')



    if !!App.table_hash

      table_hash = App.table_hash
      row = @dataView.getRowById(+table_hash)
      @grid.scrollRowIntoView(row)
      @grid.setSelectedRows([row])


    $(window).resize =>
      @grid.resizeCanvas()



  queueAndExecuteCommand: (item, column, editCommand) =>
    @commandQueue.push(editCommand)
    editCommand.execute()



  undo: =>
    command = @commandQueue.pop()
    if command && Slick.GlobalEditorLock.cancelCurrentEdit()
      command.undo()
      @grid.gotoCell(command.row, command.cell, false)


  requiredFieldValidator: (value) =>
    if (value == null || value == undefined || !value.length)
      return {valid: false, msg: "This is a required field"}
    else
    return {valid: true, msg: null}

  hideEditor: (e) =>
    window.setTimeout =>
      Slick.GlobalEditorLock.commitCurrentEdit()
    , 0

  sort: (e, args) =>
    @data = @dataView.getItems()
    cols = args.sortCols
    @data.sort (dataRow1, dataRow2) =>
      i = 0
      l = cols.length
      while i < l
        field = cols[i].sortCol.field
        sign = if cols[i].sortAsc then 1 else -1
        value1 = dataRow1[field]
        value2 = dataRow2[field]
        result = (if value1 == value2 then 0 else if value1 > value2 then 1 else -1) * sign
        if result != 0
          return result
        i++
      0
    @dataView.setItems @data


  isfetching: false
  fetchNextPage: =>
    unless @isfetching
      @isfetching = true
      $.ajax(@url+"?page=#{@page+1}").done (data) =>
        if data[@type].length
          @isfetching = false
          @page = @page + 1
          @pushFetchedData(data)
        else
          @isAllDataFetched = true

  pushFetchedData: (data) =>
    if data[@type]?.length
      for record in data[@type]
        row = record.data[0] || record.data
        row.id = record.id
        row.created_at = record.created_at || row.created_at
        row.updated_at = record.updated_at || row.updated_at
        @data.push row


      @dataView.setItems @data



  createRow: =>
    @dataView.insertItem 0,
      id: "#{Math.floor(Math.random()*100)}000000"
      isNew: true

  commitRow: (e, args) =>
    item = args.item
    if item.isNew
      @showLoader()
      row = {}

      for key, value of item
        if (key != "isNew") and (key != "id")
          row[key] = value

      name = @type.slice(0,-1)
      commit =
        "#{name}": [row]

      $.ajax
        url: @url,
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(commit)
        success: (data) =>
          @hideLoader()
          ID = item.id
          new_item = @dataView.getItemById("#{ID}")
          for key, value of data
            if value.data.length
              for k, v of value.data[0]
                new_item[k] = v
              new_item.id = "#{value.id}"
          new_item.isNew = false

          dataView.updateItem("#{ID}", new_item)
        error: (data) =>
          console.log 'error in data commit'
          @hideLoader()

    else
      commit =
        "#{name}": [row]

      PATCH(item.id, item)



  DELETE: (id) =>
    return new Promise (res, rej) =>
      $.ajax
        url: @url.replace(".json", "/#{id}.json"),
        type: "DELETE",
        contentType: "application/json",
        dataType: "json",
        success: (data) =>
          @dataView.deleteItem("#{id}")
          @grid.setSelectedRows([])
          res()

        error: (data) =>
          console.log 'error in data commit'
          rej()



  PATCH: (id, item) =>
    name = @type.slice(0,-1)
    commit =
      "#{name}": item
    return new Promise (res, rej) =>
      $.ajax
        url: @url.replace(".json", "/#{id}.json"),
        type: "PATCH",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(commit)
        success: (data) =>
          @grid.setSelectedRows([])
          res()

        error: (data) =>
          console.log 'error in data commit'
          rej()


  deleteRow: (e, args) =>

    selected = @grid.getSelectedRows()


    items = @dataView.getItems()
    selected_items = []


    for row in selected
      selected_items.push(@dataView.getItem(row))
    @showLoader()
    syncDeleteRows = (selected_items) =>
      if selected_items.length
        id = selected_items[0].id
        queue = selected_items.slice(1)
        @DELETE(id, selected_items[0]).then ->
          syncDeleteRows(queue)
      else
        @hideLoader()

    syncDeleteRows(selected_items)



  showNewColModal: =>
    App.nwModal.show 'add_data_table_col'
    that = this
    $('.add-datatable-col .save').off('click').click (event) =>
      type = $(event.target).parent().find('select')
      name = $(event.target).parent().find('input')
      if !!type.val() and !!name.val()
        that.addColumn name.val(), type.val()

        type.find('option').attr('selected', false)

        name.val('')

        App.nwModal.hide 'add_data_table_col'

  showUpdateColModal: (field) =>
    App.nwModal.show 'update_data_table_col'
    that = this
    $('.update-datatable-col').find('input').val(field)
    $('.update-datatable-col .save').off('click').click (event) =>
      name = $(event.target).parent().find('input')
      if !!name.val()
        that.updateColumnName field, name.val()

        name.val('')

        App.nwModal.hide 'update_data_table_col'

  setEditorByType: (type) =>
    switch type.toLowerCase()
      when 'string', 'float', 'decimal', 'array', 'hash'
        return Slick.Editors.Text
      when 'integer', 'number'
        return Slick.Editors.Integer
      when 'datetime'
        return Slick.Editors.DateTime
      when 'date'
        return Slick.Editors.Date
      when 'boolean'
        return Slick.Editors.Checkbox
      else
        return null


  addColumn: (name, type) =>
    cols = []
    ok = true

    for column in @columns
      if column.field.toLowerCase().split(" ").join("_") is name.toLowerCase().split(" ").join("_")

        ok = false
      if column.field != "sel"
        cols.push
          field_name: column.field
          type: column.type
          read_only: column.readonly
          editor: 'text'

    if ok
      cols.push
        field_name: name
        type: type
        read_only: false
        editor: 'text'
        visible: true
      @showLoader()
      $.ajax
        url: @url.replace("#{@type}.json",'column_values.json'),
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify
          columns: cols

      .done (data) =>
        id = null
        type = null
        for column in data.column_values
          if column.fieldname.toLowerCase().split(" ").join("_") is name.toLowerCase().split(" ").join("_")
            id = column.id
            type = column.type

        formatter = false
        if type is 'date'
          formatter = (row, cell, value, columnDef, dataContext) ->
            if value?
              return moment(new Date(value)).format('ll')
            else
              return value
        if type is 'dateTime'
          formatter = (row, cell, value, columnDef, dataContext) ->
            if value?
              return moment(new Date(value)).format('ll')
            else
              return value

        newColumn = {
          _id: id
          id: name.toLowerCase().split(" ").join("_")
          name: name.toLowerCase().split(" ").join("_")+" <span>"+type+"</span>"
          field: name.split(" ").join("_")
          editor: @setEditorByType(type)
          type: type
          readonly: false
          sortable: true
          minWidth: 150
          visible: true
          formatter: formatter

        }
        @columns.push(newColumn)
        @raw_cols.push(newColumn)
        @grid.setColumns(@columns)
        @grid.updateColumnHeader newColumn.id, newColumn.name
        @checkIfZeroData()
        @hideLoader()
    else
      swal('Oops','You already have column with this name')


  updateColumnName: (old_name, new_name) =>
    col = null
    colum = null
    ok = true
    for column in @columns
      if column.field.toLowerCase().split(" ").join("_") is new_name.toLowerCase().split(" ").join("_")
        ok = false
      if column.field != "sel"
        if column.field is old_name
          colum = column
          column.field = new_name.toLowerCase()

          col =
            column_value:
              id: column._id
              field_name: new_name
              type: column.type
              read_only: column.readonly
              editor: column.editor_name


    if ok
      @showLoader()
      $.ajax
        url: @url.replace("#{@type}.json","column_values/#{col.column_value.id}.json"),
        type: "PATCH",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(col)

      .done (data) =>
        @grid.setColumns(@columns)
        @grid.updateColumnHeader colum.id, new_name.toLowerCase()+" <span>"+col.column_value.type+"</span>"
        @checkIfZeroData()
        @hideLoader()
    else
      swal('Oops','You already have column with this name')

  updateColumnVisibility: (name, visibility) =>
    col = null
    for column in @raw_cols
      if column.field is name
        col =
          column_value:
            id: column._id
            field_name: column.field
            type: column.type
            read_only: column.readonly
            editor: column.editor_name
            visible: visibility

    $.ajax
      url: @url.replace("#{@type}.json","column_values/#{col.column_value.id}.json"),
      type: "PATCH",
      contentType: "application/json",
      dataType: "json",
      data: JSON.stringify(col)


  showRemoveColModal: =>
    App.nwModal.show 'remove_data_table_col'
    listitems = ""
    for col in @columns
      if col.field != "sel"
        listitems += "<option value='#{col.field}'>#{col.field}</option>"
    $('.remove-datatable-col .column_to_remove').find('option')
    .remove()
    .end()
    .append('<option value="">Select a column</option>')
    .append(listitems)

    $('.remove-datatable-col .delete').off('click').click (event) =>
      name = $(event.target).parent().find('select')
      @removeColumn name.val()
      name.find('option').attr('selected', false)

      App.nwModal.hide 'remove_data_table_col'

    $('.remove-datatable-col .cancel').off('click').click (event) =>
      name = $(event.target).parent().find('select')
      name.find('option').attr('selected', false)
      App.nwModal.hide 'remove_data_table_col'


  showFiltersPopup: =>
    listitems = ""
    for col in @raw_cols
      if col.field != "sel" && col.field != "created_at" && col.field != "updated_at"
        listitems += "
          <div class='nw-col_filter'>
            <div class='nw-col_filter_checkbox'>
              <input type='checkbox' name='#{col.field}' #{ if col.visible then 'checked'} />
            </div>
            <div class='nw-col_filter_name'>
              #{col.field}
            </div>
          </div>
        "

    $('.footer .nw-col_filters_popup .nw-col_filter_list').find('.nw-col_filter')
    .remove()
    .end()
    .append(listitems)

    @container.find('.footer .nw-col_filters_popup').show()
    @container.find('.footer .nw-col_filters_popup').click (event) ->
      event.stopPropagation()

    that = @
    setTimeout ->
      $('body').on 'click', ->
        $('body').off 'click'
        that.container.find('.footer .nw-col_filters_popup').hide()
    , 1

    $('.nw-col_filter_checkbox input').off('click').click ->

      name = $(this).attr('name')
      isVisible = $(this).prop('checked')
      visible_cols = []
      for col in that.raw_cols
        if col.visible && col.field != name && col.field != "sel"
          visible_cols.push(col)
        if col.field is name
          col.visible = isVisible
          if isVisible
            visible_cols.push(col)

      that.columns = that.checkColumns(visible_cols)
      for col in that.raw_cols
        if col.field is "sel"
          that.columns.unshift(col)

      that.grid.setColumns(that.columns)

      that.updateColumnVisibility(name, isVisible)



  removeColumn: (name) =>
    cols = []
    for column in @columns
      if column.field != "sel" and column.field != name
        cols.push
          field_name: column.field
          type: column.type
          read_only: column.readonly
          editor: column.editor_name

    @showLoader()
    $.ajax
      url: @url.replace("#{@type}.json",'column_values.json'),
      type: "POST",
      contentType: "application/json",
      dataType: "json",
      data: JSON.stringify
        columns: cols

    .done =>

      @refresh()


  checkIfZeroData: =>
    if @columns.length < 2
      @container.find('.table').addClass('hidden')
      $('.zero_column').addClass('shown')
    else
      @container.find('.table').removeClass('hidden')
      $('.zero_column').removeClass('shown')
      if @data.length is 0
        $('.zero_data').addClass('shown')
      else
        $('.zero_data').removeClass('shown')

    @container.find('.slick-column-name').off('click').off('dblclick').click (e) =>
      e.preventDefault()
      e.stopPropagation()
    .dblclick (e) =>
      field = $(e.target).parent().data('column')?.field? || $(e.target).parent().parent().data('column').field
      for column in @columns
        if column.field is field
          unless column.readonly
            @showUpdateColModal(field)



  showLoader: =>
    @container.find('.loader').addClass('visible')


  hideLoader: =>
    @container.find('.loader').removeClass('visible')






window.NwDataTable = NwDataTable
$(document).ready ->
  window.App.nwDataTable = new NwDataTable