class NwDeviceTable extends NwDataTable

  commitRow: (e, args) =>
    item = args.item
    if item.isNew
      @showLoader()
      row = {}
      for column in @columns
        if column.field != "sel"
          if column.editor && item[column.field]?
            row[column.field] = item[column.field] || null


      name = @type.slice(0,-1)
      commit =
        "#{name}":
          data: [row]

      $.ajax
        url: @url,
        type: "POST",
        contentType: "application/json",
        dataType: "json",
        data: JSON.stringify(commit)
        success: (data) =>
          @hideLoader()
          @dataView.deleteItem("#{item.id}")
          @grid.setSelectedRows([])
          new_item = {}
          for key, value of data
            if value[0].data?
              for k, v of value[0].data
                new_item[k] = v
              new_item.id = "#{value[0].id}"
              new_item.created_at = "#{value[0].created_at}"
              new_item.updated_at = "#{value[0].updated_at}"
          new_item.isNew = false
          @dataView.insertItem 0, new_item
        error: (data) ->
          @hideLoader()
          console.log 'error in data commit'

    else
      commit =
        "#{name}": [row]

      @PATCH(item.id, item)



  PATCH: (id, item) =>
    name = @type.slice(0,-1)
    data = {}
    for key, val of item
      if key != 'id'
        data[key] = val

    commit =
      "#{name}":
        id: id
        data: [data]
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

        error: (data) ->
          console.log 'error in data commit'
          rej()


  refresh: =>
    App.editApp.loadDeviceTable @url, 'device_results'


$(document).ready ->
  window.App.nwDeviceTable = new NwDeviceTable