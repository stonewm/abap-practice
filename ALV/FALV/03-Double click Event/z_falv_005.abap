*&---------------------------------------------------------------------*
*& Report  Z_FALV_005
*&
*&---------------------------------------------------------------------*
*& Developed by Stone Wang
*& on 2021/5/14
*&---------------------------------------------------------------------*

report  z_falv_005.

type-pools: slis.

data: gt_fieldcat type slis_t_fieldcat_alv with header line.
data: gt_mara     type standard table of mara with header line.

start-of-selection.
  perform frm_get_data.
  perform frm_disp_data.


*&---------------------------------------------------------------------*
*&      Form  frm_get_data
*&---------------------------------------------------------------------*
form frm_get_data.
  select * from mara
    into corresponding fields of table gt_mara.
endform.                    "frm_get_data


*&---------------------------------------------------------------------*
*&      Form  frm_disp_data
*&---------------------------------------------------------------------*
form frm_disp_data.
  call function 'Z_FALV_FIELD_CATALOG'
    exporting
      it_output     = gt_mara[]
    tables
      field_catalog = gt_fieldcat[].

  " set fixed column
  loop at gt_fieldcat.
    if gt_fieldcat-fieldname = 'MATNR'.
      gt_fieldcat-fix_column = 'X'.
      gt_fieldcat-key = 'X'.
      modify gt_fieldcat.
    endif.
  endloop.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program       = sy-repid " necessary for GUI_Status
      it_fieldcat              = gt_fieldcat[]
      i_callback_pf_status_set = 'FRM_GUI_STATUS'
      i_callback_user_command  = 'FRM_USER_COMMAND'
    tables
      t_outtab                 = gt_mara[].
endform.                    "frm_disp_data

*&---------------------------------------------------------------------*
*&      Form  set_gui_status
*&---------------------------------------------------------------------*
form frm_gui_status using ex_tab type slis_t_extab.
  set pf-status 'ZSTANDARD'.
endform.                    "set_gui_status

*&---------------------------------------------------------------------*
*&      Form  frm_user_command
*&---------------------------------------------------------------------*
form frm_user_command using p_ucomm    type sy-ucomm        " user command
                            p_selfield type slis_selfield.  " select field

  data: row type string,
        msg type string.

  case p_ucomm.
    when '&IC1'. " double click
      row = p_selfield-tabindex.
      concatenate 'Row:'       row
                  'Value: '    p_selfield-value
                  'Fieldname:' p_selfield-fieldname
        into msg separated by space.

      message msg type 'S'.
      if p_selfield-fieldname = 'MATNR'.
        set parameter id 'MAT' field p_selfield-value.
        set parameter id 'MXX' field 'K'.
        call transaction 'MM03' and skip first screen.
      endif.
  endcase.
endform.                    "frm_user_command