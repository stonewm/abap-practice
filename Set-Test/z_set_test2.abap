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

  call function 'G_SET_FETCH'
    exporting
      setnr            = setid
    tables
      set_lines_single = single_lines.


  loop at single_lines.
    call function 'G_SET_FETCH'
      exporting
        setnr           = single_lines-setnr
      tables
        set_lines_basic = basic_lines.

    loop at basic_lines.
      write: / single_lines-setnr,
               basic_lines-title,
               basic_lines-from,
               basic_lines-to.
    endloop.

  endloop.