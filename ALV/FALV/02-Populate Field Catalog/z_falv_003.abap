*&---------------------------------------------------------------------*
*& Report  Z_FALV_003
*&
*&---------------------------------------------------------------------*

REPORT  Z_FALV_003.

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
  call function 'REUSE_ALV_FIELDCATALOG_MERGE'
   EXPORTING
     I_PROGRAM_NAME               = sy-repid
     I_STRUCTURE_NAME             = 'SPFLI'
    changing
      ct_fieldcat                  = gt_fieldcat[] .

  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     it_fieldcat                       = gt_fieldcat[]
    tables
      t_outtab                          = gt_spfli[] .
endform.                    "frm_disp_data