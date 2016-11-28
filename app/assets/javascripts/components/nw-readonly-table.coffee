class NwReadonlyTable extends NwDataTable

  checkColumns: (columns) =>
    cols = columns
    for column in cols
      if column.editor?
        switch column.editor
          when 'text' then column.editor = Slick.Editors.Text
          when 'datePicker' then column.editor = Slick.Editors.Date
          # when 'datetimePicker' then column.editor = Slick.Editors.Date
          when 'integer' then column.editor = Slick.Editors.Integer
          when false then column.editor = null

      if column.type?
        switch column.type
          when 'date'
            column.formatter = (row, cell, value, columnDef, dataContext) ->
              return moment(value).format('ll')
          when 'datetime'
            column.formatter = (row, cell, value, columnDef, dataContext) ->
              return moment(value).format('lll')

    return cols

  afterInit: =>
    @container.find('.footer .cols, .footer .rows').hide()

  refresh: =>
    App.editApp.loadReadonlyTable @url, @type


$(document).ready ->
  window.App.nwReadonlyTable = new NwReadonlyTable