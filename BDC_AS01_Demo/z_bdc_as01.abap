*&---------------------------------------------------------------------*
*& Report  Z_BDC_AS01
*& Developed by Stone Wang
*% on 2020/11/25
*&---------------------------------------------------------------------*


REPORT  z_bdc_as01.

INCLUDE zbdcrecx.

TYPE-POOLS: truxs.

DATA: lt_raw TYPE truxs_t_text_data.

DATA: BEGIN OF record OCCURS 0,
        anlkl_001(008),    " asset class
        bukrs_002(004),    " company code
        nassets_003(003),  " quantity
        txt50_004(050),    " description
        meins_005(003),    " unit of measure
        kostl_006(010),    " cost center
      END OF record.

PARAMETERS: p_file LIKE ibipparms-path.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.  " F4 help for p_file
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_FILE'
    IMPORTING
      file_name  = p_file.


START-OF-SELECTION.
  PERFORM upload_excel_to_itab.

  CHECK NOT record[] IS INITIAL.

  LOOP AT record.
    PERFORM bdc_dynpro      USING 'SAPLAIST'      '0105'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '/00'.
    PERFORM bdc_field       USING 'ANLA-ANLKL'    record-anlkl_001.
    PERFORM bdc_field       USING 'ANLA-BUKRS'    record-bukrs_002.
    PERFORM bdc_field       USING 'RA02S-NASSETS' record-nassets_003.

    PERFORM bdc_dynpro      USING 'SAPLAIST'      '1000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '=TAB02'.
    PERFORM bdc_field       USING 'ANLA-TXT50'    record-txt50_004.
    PERFORM bdc_field       USING 'ANLA-MEINS'    record-meins_005.

    PERFORM bdc_dynpro      USING 'SAPLAIST'      '1000'.
    PERFORM bdc_field       USING 'BDC_OKCODE'    '=BUCH'.
    PERFORM bdc_field       USING 'ANLZ-KOSTL'    record-kostl_006.

    PERFORM bdc_transaction USING 'AS01' 'N'.

    CLEAR record.
  ENDLOOP.


*&---------------------------------------------------------------------*
*&      Form  upload_excel_to_itab
*&---------------------------------------------------------------------*
*       upload excel file to internal table
*----------------------------------------------------------------------*
FORM upload_excel_to_itab.
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = 'X' " 有表头，从第二行开始读取数据
      i_tab_raw_data       = lt_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = record[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
ENDFORM.                    "upload_excel_to_itab