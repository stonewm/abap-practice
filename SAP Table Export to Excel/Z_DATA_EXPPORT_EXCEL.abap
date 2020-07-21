*&---------------------------------------------------------------------*
*& Report  Z_DATA_EXPPORT_EXCEL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  z_data_expport_excel.

" GXXLT_V: Headings for DATA columns
DATA BEGIN OF gt_gxxlt_v OCCURS 1.
        INCLUDE STRUCTURE gxxlt_v.
DATA END OF gt_gxxlt_v.


" GXXLT_O: table with online text
DATA BEGIN OF gt_gxxlt_o OCCURS 1.
        INCLUDE STRUCTURE gxxlt_o.
DATA END OF gt_gxxlt_o.


" GXXLT_P: Table with print texts
DATA BEGIN OF gt_gxxlt_p OCCURS 1.
        INCLUDE STRUCTURE gxxlt_p.
DATA END OF gt_gxxlt_p.


DATA: BEGIN OF gt_spfli OCCURS 0,
        carrid LIKE spfli-carrid,
        connid LIKE spfli-connid,
        airpfrom LIKE spfli-airpfrom,
        airpto   LIKE spfli-airpto,
        deptime  LIKE spfli-deptime,
        arrtiem  LIKE spfli-arrtime,
     END OF gt_spfli.


START-OF-SELECTION.
  PERFORM get_data.
  PERFORM export_data_to_excel.

*  Form get_data
FORM get_data.

  SELECT * FROM spfli
    INTO CORRESPONDING FIELDS OF TABLE gt_spfli.

ENDFORM.                    "get_data

FORM fill_gxxlt_v USING no name.

  CLEAR gt_gxxlt_v.
  gt_gxxlt_v-col_no = no.
  gt_gxxlt_v-col_name = name.
  APPEND gt_gxxlt_v.

ENDFORM.                    "fill_gxxl_v

FORM export_data_to_excel.

  perform fill_gxxlt_v using 1 '公司'.
  perform fill_gxxlt_v using 2 '航班'.
  perform fill_gxxlt_v using 3 '从机场'.
  perform fill_gxxlt_v using 4 '到机场'.
  perform fill_gxxlt_v using 5 '出发时间'.
  perform fill_gxxlt_v using 6 '达到时间'.


  CALL FUNCTION 'XXL_SIMPLE_API'
    EXPORTING
      filename          = 'XMPL0002'
      header            = space
      n_key_cols        = 2
    TABLES
      col_text          = gt_gxxlt_v[]
      data              = gt_spfli[]
      online_text       = gt_gxxlt_o[]
      print_text        = gt_gxxlt_p[]
    EXCEPTIONS
      dim_mismatch_data = 1
      file_open_error   = 2
      file_write_error  = 3
      inv_winsys        = 4
      inv_xxl           = 5
      OTHERS            = 6.


  CASE sy-subrc.
    WHEN 1. WRITE 'mismatch data.'.
    WHEN 2. WRITE 'open error'.
    WHEN 3. WRITE 'write error'.
    WHEN 4. WRITE 'inv_winsys'.
    WHEN 5. WRITE 'inv_xxl'.
    WHEN 6. WRITE 'other error.'.
  ENDCASE.

ENDFORM.                    "export_data_to_excel