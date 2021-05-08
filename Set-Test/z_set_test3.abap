report  z_set_test.

data setid        like sethier-setid.
data: setvalues    type standard table of rgsb4 with header line.


start-of-selection.

  call function 'G_SET_GET_ALL_VALUES'
    exporting
      client     = sy-mandt
      setnr      = 'ZBS'
      table      = 'SKB1'
      class      = '0000'
      fieldname  = 'SAKNR'
    tables
      set_values = setvalues.

  loop at setvalues.
    write: / setvalues-shortname,
              setvalues-field,
              setvalues-from,
              setvalues-to.
  endloop.