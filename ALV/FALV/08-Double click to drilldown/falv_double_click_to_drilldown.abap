*&---------------------------------------------------------------------*
*& Report  ZFALV_DBL_CLICK
*& Written by Stone Wang
*&---------------------------------------------------------------------*


report  zfalv_dbl_click.

type-pools: slis.

data: gt_scarr type standard table of scarr,
      gs_scarr like line of gt_scarr.

data: gt_spfli type standard table of spfli,
      gs_spfli like line of gt_spfli.


start-of-selection.
  perform get_scarr_data.
  perform frm_disp_data.


*&---------------------------------------------------------------------*
*&      Form  get_scarr_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form get_scarr_data.
  select * from scarr
    into table gt_scarr.
endform.                    "get_scarr_data

*&---------------------------------------------------------------------*
*&      Form  get_spfli_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form get_spfli_data using p_carrid like scarr-carrid.
  select * from spfli
    into table gt_spfli
   where carrid = p_carrid.
endform.                    "get_spfli_data



*&---------------------------------------------------------------------*
*&      Form  frm_disp_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form frm_disp_data.
  data: lt_fieldcat type slis_t_fieldcat_alv,
        ls_fieldcat type slis_fieldcat_alv.

  clear lt_fieldcat[] .

  call function 'Z_FALV_FIELD_CATALOG'
    exporting
      it_output     = gt_scarr[]
    tables
      field_catalog = lt_fieldcat[].


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      i_callback_program      = sy-repid
      i_callback_user_command = 'FRM_USER_COMMAND'
      it_fieldcat             = lt_fieldcat[]
    tables
      t_outtab                = gt_scarr[].
endform.                    "frm_disp_data


*&---------------------------------------------------------------------*
*&      Form  frm_disp_spfli_data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form frm_disp_spfli_data.
  data: lt_fieldcat type slis_t_fieldcat_alv,
        ls_fieldcat type slis_fieldcat_alv.

  clear lt_fieldcat[] .

  call function 'Z_FALV_FIELD_CATALOG'
    exporting
      it_output     = gt_spfli[]
    tables
      field_catalog = lt_fieldcat[].

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      it_fieldcat = lt_fieldcat[]
    tables
      t_outtab    = gt_spfli[].
endform.                    "frm_disp_data


*&---------------------------------------------------------------------*
*&      Form  frm_user_command
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->R_UCOMM      text
*      -->RS_SELFIELD  text
*----------------------------------------------------------------------*
form frm_user_command using r_ucomm like sy-ucomm
                  rs_selfield type slis_selfield
.
  case r_ucomm.
    when '&IC1'. " double click
      clear gs_scarr.
      read table gt_scarr into gs_scarr index rs_selfield-tabindex.
      check sy-subrc = 0.

      if rs_selfield-sel_tab_field = 'SCARR-CARRID'.
        perform get_spfli_data using gs_scarr-carrid.
        perform frm_disp_spfli_data.
      endif.
  endcase.
endform.                    "frm_user_command