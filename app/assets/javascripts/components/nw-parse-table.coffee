class NwParseTable extends NwDataTable


  afterInit: =>
    @container.find('.footer .rows').show()
    @container.find('.footer .cols').hide()
    @checkIfZeroData()
    Parse.serverURL = "#{window.location.protocol}//parse.nuwe.co:#{@params.meta.port}/parse"
    Parse._initialize "#{@params.meta.app_id}", "#{@params.meta.client_key}", "#{@params.meta.master_key}"



  rest_url: =>
    return "#{window.location.protocol}//parse.nuwe.co:#{@params.meta.port}/parse/classes/#{@params.className}"

  getRequestHeaders: =>
    return {
        'X-Parse-Application-Id': "#{@params.meta.app_id}"
        'X-Parse-Master-Key': "#{@params.meta.master_key}"
        'Content-Type': 'application/json'
      }




  commitRow: (e, args) =>
    item = args.item
    id = item.id || item.objectId
    if item.isNew
      @showLoader()
      row = {}
      for column in @columns
        if column.field != "sel" && column.field != "id"
          if column.editor && item[column.field]?
            row[column.field] = item[column.field] || null


      fetch(@rest_url(), {
        'method': 'POST',
        'headers': @getRequestHeaders()
        'mode': 'cors'
        'body': JSON.stringify(row)
      })
      .then (response) =>
        response.json()
      .then (data) =>
        @dataView.deleteItem("#{id}")
        @grid.setSelectedRows([])

        new_item = {}
        for k, v of row
          new_item[k] = v

        new_item.objectId = "#{data.objectId}"
        new_item.id = "#{data.objectId}"
        new_item.createdAt = "#{data.createdAt}"
        new_item.updatedAt = "#{data.createdAt}"
        new_item.isNew = false
        @dataView.insertItem 0, new_item

        @hideLoader()


      .catch (e) =>
        console.log 'error in data commit:', e
        @hideLoader()


    else
      # commit =
      #   "#{name}": [row]

      @PATCH(id, item)



  PATCH: (id, item) =>

    name = @type.slice(0,-1)
    data = {}
    for key, val of item
      if key != 'objectId' && key != 'id'
        data[key] = val

    return new Promise (res, rej) =>

      fetch(@rest_url()+'/'+id, {
        'method': 'PUT',
        'headers': @getRequestHeaders()
        'mode': 'cors'
        'body': JSON.stringify(data)
      })
      .then (data) =>
        @grid.setSelectedRows([])
        res()

      .catch (data) =>
        console.log 'error in data commit'
        rej()

  DELETE: (id) =>

    return new Promise (res, rej) =>
      fetch(@rest_url()+'/'+id, {
        'method': 'DELETE',
        'headers': @getRequestHeaders()
        'mode': 'cors'
      })
      .then (data) =>
        @dataView.deleteItem("#{id}")
        @grid.setSelectedRows([])
        res()

      .catch (data) =>
        console.log 'error in data commit'
        rej()


  refresh: =>
    App.editApp.loadParseTable @url, 'parse'


$(document).ready ->
  window.App.nwParseTable = new NwParseTable
