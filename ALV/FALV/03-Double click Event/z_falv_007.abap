*&---------------------------------------------------------------------*
*& Report  Z_FALV_007
*&
*&---------------------------------------------------------------------*
*& Developed by Stone Wang
*& on 2021/5/19
*&---------------------------------------------------------------------*

report  z_falv_007.

type-pools: slis.

data: gt_fieldcat type slis_t_fieldcat_alv with header line.
data: gt_spfli type standard table of spfli with header line.

start-of-selection.
  perform frm_get_data.
  perform frm_disp_data.


*&---------------------------------------------------------------------*
*&      Form  frm_get_data
*&---------------------------------------------------------------------*
form frm_get_data.
  select * from spfli
    into corresponding fields of table gt_spfli.
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

  " set color
  loop at gt_fieldcat.
    if gt_fieldcat-fieldname = 'CITYFROM' or gt_fieldcat-fieldname = 'CITYTO'.
      gt_fieldcat-emphasize = 'C500'.
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
      t_outtab                 = gt_spfli[].
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

  "用户操作
  case p_ucomm.
    when '&IC1'.  "双击显示明细
      read table gt_spfli index p_selfield-tabindex.
      p_ucomm = '&ETA'.  "调用系统功能，查看明细
  endcase.
endform.                    "frm_user_command