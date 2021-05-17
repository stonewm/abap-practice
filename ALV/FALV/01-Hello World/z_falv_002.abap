*&---------------------------------------------------------------------*
*& Report  Z_FALV_002
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  z_falv_002.

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
  perform frm_build_fieldcat using gt_spfli[] gt_fieldcat[].

  check not gt_spfli[] is initial.
  check not gt_fieldcat[] is initial.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
      it_fieldcat = gt_fieldcat[]
    tables
      t_outtab    = gt_spfli[].
endform.                    "frm_disp_data

*&---------------------------------------------------------------------*
*&      Form  frm_build_fieldcat
*&---------------------------------------------------------------------*
form frm_build_fieldcat using pt_data type any table
                              pt_fieldcat type slis_t_fieldcat_alv.
  data: lt_ddfields type ddfields,
        ls_fields   type dfies.

  data: lt_fieldcat_lvc type lvc_t_fcat,
        ls_fieldcat_lvc like line of lt_fieldcat_lvc.

  data: ls_fieldcat type slis_fieldcat_alv.

  perform frm_get_fields using pt_data[] changing lt_ddfields[].

  loop at lt_ddfields into ls_fields.
    move-corresponding ls_fields to ls_fieldcat.
    append ls_fieldcat to pt_fieldcat.
    clear ls_fieldcat.
  endloop.
endform.                    "frm_build_fieldcat

*&---------------------------------------------------------------------*
*&      Form  frm_get_fields
*&---------------------------------------------------------------------*
form frm_get_fields using    pt_data     type any table
                    changing pt_fields   type ddfields.

  data: lr_tabdescr  type ref to cl_abap_structdescr,
        lr_data      type ref to data,
        lt_fields    type ddfields,
        ls_fields    type dfies,
        ls_fieldcat  type lvc_s_fcat.

  create data lr_data like line of pt_data.

  lr_tabdescr ?= cl_abap_structdescr=>describe_by_data_ref( lr_data ).
  lt_fields    = cl_salv_data_descr=>read_structdescr( lr_tabdescr ).

  pt_fields = lt_fields.
endform.                    "frm_get_fields