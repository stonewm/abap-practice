report  z_falv_011.

type-pools: slis.

data: gt_fieldcat type slis_t_fieldcat_alv,
      gs_fieldcat type slis_fieldcat_alv.

data: gt_spfli type standard table of spfli.

start-of-selection.
  perform frm_get_data.
  perform frm_disp_data.

*&---------------------------------------------------------------------*
*&      Form  frm_get_data
*&---------------------------------------------------------------------*
form frm_get_data.
  select * from spfli into table gt_spfli.
endform.                    "frm_get_data

*&---------------------------------------------------------------------*
*&      Form  frm_disp_data
*&---------------------------------------------------------------------*
form frm_disp_data.
  call function 'Z_FALV_FIELD_CATALOG'
    exporting
      it_output     = gt_spfli[]
    tables
      field_catalog = gt_fieldcat[].


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program       = sy-repid
      i_callback_pf_status_set = 'FRM_GUI_STATUS'
      i_callback_user_command  = 'FRM_USER_COMMAND'
      it_fieldcat              = gt_fieldcat[]
    tables
      t_outtab                 = gt_spfli[].

endform.                    "frm_disp_data


*&---------------------------------------------------------------------*
*&      Form  frm_status_set
*&---------------------------------------------------------------------*
form frm_gui_status using ex_tab type slis_t_extab.
  " remove send mail button
  data: ls_extab type line of slis_t_extab.
  ls_extab-fcode = '%SL'.
  append ls_extab-fcode to ex_tab.

  set pf-status 'ZSTANDARD' excluding ex_tab immediately.
endform.                    "frm_status_set


*&---------------------------------------------------------------------*
*&      Form  user_command
*&---------------------------------------------------------------------*
form frm_user_command using p_ucomm    type sy-ucomm        " user command
                            p_selfield type slis_selfield.  " select field
  case p_ucomm.
    when 'EXCEL'.
      call function 'ZITAB_TO_EXCEL'
        exporting
          internal_tab = gt_spfli[].
  endcase.
endform.                    "user_command