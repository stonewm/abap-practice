FUNCTION z_table_to_excel.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_TABLENAME) TYPE  DD02L-TABNAME
*"     VALUE(I_OPTIONS) TYPE  CHAR1024 DEFAULT SPACE
*"     VALUE(I_SORT) TYPE  CHAR1024 DEFAULT SPACE
*"  EXCEPTIONS
*"      DIM_MISMATCH_DATA
*"      FILE_OPEN_ERROR
*"      FILE_WRITE_ERROR
*"      INV_WINSYS
*"      INV_XXL
*"----------------------------------------------------------------------

  DATA dref TYPE REF TO data.

  DATA: tabledescr_ref TYPE REF TO cl_abap_tabledescr,
        descr_ref      TYPE REF TO cl_abap_structdescr,
        comp_descr     TYPE        abap_compdescr.

  DATA: t_heading TYPE TABLE OF gxxlt_v WITH HEADER LINE,
        t_online  TYPE TABLE OF gxxlt_o,
        t_print   TYPE TABLE OF gxxlt_p.

  FIELD-SYMBOLS <fs> TYPE STANDARD TABLE.


  CREATE DATA dref TYPE STANDARD TABLE OF (i_tablename).
  ASSIGN dref->* TO <fs>.

  tabledescr_ref ?= cl_abap_typedescr=>describe_by_data( <fs> ).
  descr_ref ?= tabledescr_ref->get_table_line_type( ).

  SELECT * FROM (i_tablename) INTO TABLE <fs>
    WHERE    (i_options)
    ORDER BY (i_sort).

  LOOP AT descr_ref->components INTO comp_descr.
    t_heading-col_no = sy-tabix.
    t_heading-col_name = comp_descr-name.
    APPEND t_heading.
  ENDLOOP.

  CALL FUNCTION 'XXL_SIMPLE_API'
    TABLES
      col_text          = t_heading " heading, column text
      data              = <fs>
      online_text       = t_online
      print_text        = t_print
    EXCEPTIONS
      dim_mismatch_data = 1
      file_open_error   = 2
      file_write_error  = 3
      inv_winsys        = 4
      inv_xxl           = 5
      OTHERS            = 6.

  CASE sy-subrc.
    WHEN 1. RAISE dim_mismatch_data.
    WHEN 2. RAISE file_open_error.
    WHEN 3. RAISE file_write_error.
    WHEN 4. RAISE inv_winsys.
    WHEN 5. RAISE inv_xxl.
  ENDCASE.

ENDFUNCTION.