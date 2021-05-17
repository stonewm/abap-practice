*&---------------------------------------------------------------------*
*& Report  Z_FALV_001
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  z_falv_001.

type-pools: slis.

data: gt_fieldcat type slis_t_fieldcat_alv,
      gs_fieldcat type slis_fieldcat_alv.

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
  perform frm_build_fieldcat using 'CARRID'    'L' '航班号'.
  perform frm_build_fieldcat using 'COUNTRYFR' 'L' '从国家'.
  perform frm_build_fieldcat using 'CITYFROM'  'L' '从城市'.
  perform frm_build_fieldcat using 'AIRPFROM'  'L' '从机场'.
  perform frm_build_fieldcat using 'COUNTRYTO' 'L' '到国家'.
  perform frm_build_fieldcat using 'COUNTRYTO' 'L' '到城市'.
  perform frm_build_fieldcat using 'AIRPTO'    'L' '到机场'.

  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     it_fieldcat                       = gt_fieldcat[]
    tables
      t_outtab                          = gt_spfli[] .
endform.                    "frm_disp_data

*&---------------------------------------------------------------------*
*&      Form  frm_build_fieldcat
*&---------------------------------------------------------------------*
form frm_build_fieldcat using fieldname justify seltext.
  clear gs_fieldcat.
  gs_fieldcat-fieldname = fieldname.
  gs_fieldcat-just = justify.
  gs_fieldcat-seltext_m = seltext.
  gs_fieldcat-seltext_s = seltext.
  gs_fieldcat-seltext_l = seltext.
  append gs_fieldcat to gt_fieldcat.
endform.                    "frm_build_fieldcat