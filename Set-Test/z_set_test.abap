*&---------------------------------------------------------------------*
*& Report  Z_SET_TEST
*&
*&---------------------------------------------------------------------*

report  z_set_test.

data setid        like sethier-setid.

data: setvalues    type standard table of rgsb4 with header line,
      single_lines type standard table of rgsb1 with header line,
      basic_lines  type standard table of rgsbv with header line.


start-of-selection.

  call function 'G_SET_GET_ID_FROM_NAME'
    exporting
      shortname = 'ZBS'
    importing
      new_setid = setid.


  call function 'G_SET_GET_ALL_VALUES'
    exporting
      setnr      = setid
    tables
      set_values = setvalues.

  loop at setvalues.
    write: / setvalues-shortname,
             setvalues-field,
             setvalues-from,
             setvalues-to.
  endloop.