```
GET   /table   #index
— returns all data and columns
— request: empty
— response:
{
  table_data: {
    data: [
      {id:xx,temp:24,hum:26},
      {id:xx,temp:24,hum:26},
      {id:xx,temp:24,hum:26}
    ],
    columns: [
      {column},
      {column},
      {column}
    ]
  }
}

###==> [This what we have now]
###<== Nope, we have that:

{
  table_data: [
    {id: 1, data: array[{temp: 24},{hum: 26},{created_at: 2015}], columns: array[{column},{column},{column}]},
    {id: 2, data: array[{temp: 24},{hum: 26},{created_at: 2015}], columns: array[{column},{column},{column}]},
    {id: 3, data: array[{temp: 24},{hum: 26},{created_at: 2015}], columns: array[{column},{column},{column}]
  ]
}

###<== [ each device_result has its own columns! ]
###<== [ and own dataset ]




POST   /table   #create
— creates new row, returns this row with ID in db
— request: {new_row: {temp: 24, hum: 26, created_at: 2015}}
— response: {created_record: {id: xx,temp: 24,hum: 26,created_at: 2015}}

###==> [I can remove the columns. Are you sure you want the device_result.id in the data array?]
###<== [columns = keys of each param. I need just ID of newly created row]



PATCH  /table/:record_id   #update
— updates record by ID
— request:  {new_row: {temp: 24, hum: 26, created_at: 2015}}
— response: {updated_record: {temp: 24, hum: 26, created_at: 2015}}


DELETE  /table/:record_id   #delete
— delete record by ID
— request:  empty
— response: {removed_record: {temp: 24, hum: 26, created_at: 2015}} (edited)
###==> [This what we have now, minus the id reflected in the data array. Please not that if the record holds more instances of data, they will all be removed]





GET   /table/column   #index
— returns all columns
— request: empty
— response: {columns: array[{column},{column},{column}]}
###==> [Can build]
###<== [Just for consistency]

POST   /table/column   #create
— returns all columns
— request: {params: {column_name: 26},{type: text}}
— response: {column: {id: 24},{column_name: 26},{type: text}}
###==> [Can build]
###<== [To create new column from interface]


PATCH   /table/column/:id   #update
— updates column by ID
— request: {params: {column_name: 26},{type: text}}
— response: {column: {id: 24},{column_name: 26},{type: text}}
###==> [Do you not need the ID's in the array like above?]




DELETE   /table/column/:id   #delete
— delete column by ID
— request: empty
— response: {column: {id: 24},{column_name: 26},{type: text}}
###==> [Do you not need the ID's in the array like above?]






```