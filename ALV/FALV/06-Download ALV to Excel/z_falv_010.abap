report z_falv_010.


data: gt_spfli type standard table of spfli with header line.

data: gt_fieldcat type lvc_t_fcat with header line.
data: gr_data     type ref to data.

start-of-selection.
  perform frm_get_data.
  perform frm_disp_data.


form frm_get_data.
  select * from spfli
    into table gt_spfli.
endform.


form frm_disp_data.
  perform frm_build_fieldcat using gt_spfli[] changing gt_fieldcat[].

  call function 'REUSE_ALV_GRID_DISPLAY_LVC'
    exporting
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'FRM_GUI_STATUS'
      i_callback_user_command  = 'FRM_USER_COMMAND'
      it_fieldcat_lvc          = gt_fieldcat[]
    tables
      t_outtab                 = gt_spfli[].
endform.


form frm_get_fields using    pt_data     type any table
                    changing pt_fields   type ddfields.

  data: lr_tabdescr type ref to cl_abap_structdescr,
        lr_data     type ref to data,
        lt_fields   type ddfields,
        ls_fields   type dfies,
        ls_fieldcat type lvc_s_fcat.

  create data lr_data like line of pt_data.

  lr_tabdescr ?= cl_abap_structdescr=>describe_by_data_ref( lr_data ).
  lt_fields    = cl_salv_data_descr=>read_structdescr( lr_tabdescr ).

  pt_fields = lt_fields.
endform.


form frm_build_fieldcat using pt_data     type any table
                              pt_fieldcat type lvc_t_fcat.
  data: lt_ddfields type ddfields,
        ls_fields   type dfies.

  data: lt_fieldcat_lvc type lvc_t_fcat,
        ls_fieldcat_lvc type lvc_s_fcat.

  perform frm_get_fields using pt_data[] changing lt_ddfields[].

  loop at lt_ddfields into ls_fields.
    move-corresponding ls_fields to ls_fieldcat_lvc.
    append ls_fieldcat_lvc to pt_fieldcat.
    clear ls_fieldcat_lvc.
  endloop.
endform.


form frm_export_excel using p_itab type standard table.
  data: file_length type i.
  data: lt_stream   type salv_xml_xline_tabtype.
  data: file_name   type string.

  data: xls_export_tool  type ref to   cl_salv_export_tool_xls,
        export_config    type ref to   if_salv_export_configuration,
        file_content     type          cl_salv_export_tool=>y_file_content,
        export_exception type ref to   cx_salv_export_error.

  " Create an instance of the Excel export tool
  get reference of p_itab into gr_data.
  xls_export_tool = cl_salv_export_tool=>create_for_excel( gr_data ).

  " Configure export properties
  export_config = xls_export_tool->configuration( ).

  " Populate header
  loop at gt_fieldcat.
    export_config->add_column( header_text  = |{ gt_fieldcat-coltext }|
                               field_name   = |{ gt_fieldcat-fieldname }|
                               display_type  = if_salv_export_column_conf=>display_types-text_view ).
    clear gt_fieldcat.
  endloop.

  " exports R_DATA to requested format
  try.
      xls_export_tool->read_result(
        importing content = file_content ).
    catch cx_salv_export_error into export_exception.
      message id export_exception->if_t100_message~t100key-msgid
              type 'E'
              number export_exception->if_t100_message~t100key-msgno .
  endtry.

  " Set Filename
  file_name = 'D:\Downloads\spfli.xlsx'.

  " Convert to Binary
  call function 'SCMS_XSTRING_TO_BINARY'
    exporting
      buffer        = file_content
    importing
      output_length = file_length
    tables
      binary_tab    = lt_stream.

  " Download file using binary format
  cl_gui_frontend_services=>gui_download(
    exporting
      bin_filesize = file_length
      filetype     = 'BIN'
      filename     = file_name
    changing
      data_tab     = lt_stream
    exceptions
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      not_supported_by_gui    = 22
      error_no_gui            = 23
      others                  = 24 ).
  if sy-subrc <> 0.
    message 'Fail to download the file.' type 'E'.
  else.
    message 'Download the file successfully.' type 'S'.
  endif.
endform.


form frm_gui_status using ex_tab type slis_t_extab.
  set pf-status 'ZSTANDARD'.
endform.                    "frm_status_set


form frm_user_command using p_ucomm    type sy-ucomm        " user command
                            p_selfield type slis_selfield.  " select field

  case p_ucomm.
    when '&EXCEL'.
      perform frm_export_excel using gt_spfli[].
  endcase.
endform.