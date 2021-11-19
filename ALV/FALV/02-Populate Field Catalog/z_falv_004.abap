*&---------------------------------------------------------------------*
*& Report  Z_FALV_004
*&
*&---------------------------------------------------------------------*

report  z_falv_004.

type-pools: slis.

data: gt_fieldcat type slis_t_fieldcat_alv,
      gs_fieldcat type slis_fieldcat_alv.

" 定义结构的时候， type后面只能跟基本类型（不是指date element）
" 其他任何都只能用like
data: begin of gt_spfli occurs 0,
          carrid    like spfli-carrid,
          countryfr like spfli-countryfr,
          cityfrom  like spfli-cityfrom,
          airpfrom  like spfli-airpfrom,
          countryto like spfli-countryto,
          cityto    like spfli-cityto,
          airpto    like spfli-airpto,
      end of gt_spfli.


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
  "  参照内表， i_program_name 和 i_inclname 参数都要写为sy-repid
  call function 'REUSE_ALV_FIELDCATALOG_MERGE'
    exporting
      i_program_name     = sy-repid
      i_inclname         = sy-repid
      i_internal_tabname = 'GT_SPFLI'
    changing
      ct_fieldcat        = gt_fieldcat.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      it_fieldcat = gt_fieldcat[]
    tables
      t_outtab    = gt_spfli[].
endform.                    "frm_disp_data