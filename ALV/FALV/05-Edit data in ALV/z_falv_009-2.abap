*&---------------------------------------------------------------------*
*& Report  Z_FALV_009
*&
*&---------------------------------------------------------------------*

report  z_falv_009.

type-pools: slis.

data: gt_fieldcat type slis_t_fieldcat_alv,
      gs_fieldcat type slis_fieldcat_alv.

data:gt_spfli type standard table of spfli,
     gs_spfli like line of gt_spfli.

start-of-selection.
  perform frm_get_data.
  perform frm_disp_data.


*&---------------------------------------------------------------------*
*&      Form  frm_get_data
*&---------------------------------------------------------------------*
form frm_get_data.
  select * from spfli
    into table gt_spfli.
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

  " make ALV editable if field is not a key
  loop at gt_fieldcat into gs_fieldcat.
    if gs_fieldcat-key = 'X'.
      gs_fieldcat-edit = ''.
    else.
      gs_fieldcat-edit = 'X'.
    endif.
    modify gt_fieldcat from gs_fieldcat.
    clear gs_fieldcat.
  endloop.

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
*&      Form  frm_gui_status
*&---------------------------------------------------------------------*
form frm_gui_status using ex_tab type slis_t_extab.
  set pf-status 'ZSTANDARD'.
endform.                    "frm_status_set


*&---------------------------------------------------------------------*
*&      Form  frm_user_command
*&---------------------------------------------------------------------*
form frm_user_command using p_ucomm    type sy-ucomm        " user command
                            p_selfield type slis_selfield.  " select field

  data: r_alv_grid type ref to cl_gui_alv_grid.

  case p_ucomm.
    when '&SAVE'.
      if r_alv_grid is initial.
        call function 'GET_GLOBALS_FROM_SLVC_FULLSCR'
          importing
            e_grid = r_alv_grid.
      endif.

      if not r_alv_grid is initial.
        call method r_alv_grid->check_changed_data.
      endif.

      p_selfield-refresh = 'X'.

      " save data to db
      update spfli from table gt_spfli.

      if sy-subrc is initial.
        message 'Data was saved successfully.' type 'S'.
      else.
        message 'Data was not saved, errors ocured.' type 'S'.
      endif.
  endcase.
endform.                    "frm_user_command