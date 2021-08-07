*&---------------------------------------------------------------------*
*& Report  Z_FALV_006
*&
*&---------------------------------------------------------------------*

REPORT  Z_FALV_006.

type-pools: slis.

data: gt_fieldcat type slis_t_fieldcat_alv with header line.

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
  call function 'Z_FALV_FIELD_CATALOG'
    exporting
      it_output           = gt_spfli[]
    tables
      field_catalog       = gt_fieldcat[].


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      it_fieldcat = gt_fieldcat[]
    tables
      t_outtab    = gt_spfli[].
endform.                    "frm_disp_data