*&---------------------------------------------------------------------*
*& Report  Z_DOWNLOAD_SERVER_FILE
*&
*&---------------------------------------------------------------------*

REPORT  z_download_server_file.

" --Neccessary for operation of EXCEL using OLE----------------------------
INCLUDE ole2incl.

" handles for OLE objects
DATA: excelapp  TYPE ole2_object,         " Excel object
      workbooks TYPE ole2_object,         " workbooks
      workbook  TYPE ole2_object,         " workbook
      sheet     TYPE ole2_object,         " Sheet
      row       TYPE ole2_object,         " Row
      cell      TYPE ole2_object,         " cell
      font      TYPE ole2_object.         " font

DATA: local_file LIKE rlgrap-filename.

DATA: is_file_downloaded TYPE c.

START-OF-SELECTION.
  " screen
  PARAMETERS: p_file TYPE rlgrap-filename DEFAULT 'D:/employees.xls'.


  PERFORM frm_download_excel_file.

  IF is_file_downloaded = 'X'.
    PERFORM frm_write_excel.
    PERFORM frm_save_excel.
    WRITE: 'Successful.'.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  frm_download_excel
*&---------------------------------------------------------------------*
FORM frm_download_excel_file.
  DATA: ls_wwwdata  LIKE wwwdatatab.
  DATA: l_return LIKE sy-subrc.

  "local_file = 'D:/employees.xls'.

  "检查否存在所指定的模板文件
  SELECT SINGLE *
     FROM wwwdata
    INNER JOIN tadir
       ON wwwdata~objid = tadir~obj_name
     INTO CORRESPONDING FIELDS OF ls_wwwdata
    WHERE wwwdata~srtf2  = 0
      AND wwwdata~relid  = 'MI'                "标识二进制的对象
      AND tadir~pgmid    = 'R3TR'
      AND tadir~object   = 'W3MI'
      AND tadir~obj_name = 'Z_EMPLOYEES_EXCEL'."模板文件名

  IF sy-subrc EQ 0.
    "如果文件存在，调用DOWNLOAD_WEB_OBJECT 函数下载模板文件
    CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
      EXPORTING
        key         = ls_wwwdata
        destination = p_file
      IMPORTING
        rc          = l_return.  " return code

    IF l_return EQ 0.
      is_file_downloaded = 'X'.
      local_file = p_file.
    ELSE.
      WRITE :'Download failed.'.
    ENDIF.

  ENDIF.
ENDFORM.                    "frm_download_excel

*&---------------------------------------------------------------------*
*&      Form  WRITE_EXCEL
*&---------------------------------------------------------------------*
FORM frm_write_excel.
  " Create Excel object.
  CREATE OBJECT excelapp 'EXCEL.APPLICATION'.
  IF sy-subrc NE 0.
    WRITE : 'Excel Application Creation Error.'.
  ENDIF.
  SET PROPERTY OF excelapp 'Visible' = 0.  " Hide the application
  SET PROPERTY OF excelapp 'DisplayAlerts' = 0.

  " Open workbook
  CALL METHOD OF excelapp 'Workbooks' = workbooks.
  CALL METHOD OF workbooks 'Open'
    EXPORTING
    #1 = local_file.

  CALL METHOD OF excelapp 'Sheets' = sheet
    EXPORTING
    #1 = 1.

  CALL METHOD OF sheet 'Select' .
  CALL METHOD OF sheet 'ACTIVATE'.

  "更改Worksheet的内容
  PERFORM frm_fill_cell.
ENDFORM.                    "write_excel

*&---------------------------------------------------------------------*
*&      Form  do_fill_cell
*&---------------------------------------------------------------------*
FORM do_fill_cell USING value(f_row) value(f_col) value(f_value).
  DATA:
    row TYPE i,
    col TYPE i.

  row = f_row.
  col = f_col.

  CALL METHOD OF excelapp 'CELLS' = cell
    EXPORTING
    #1 = row
    #2 = col.
  SET PROPERTY OF cell 'VALUE' = f_value.
ENDFORM.                    "do_fill_cell


*&---------------------------------------------------------------------*
*&      Form  fill_cell
*&---------------------------------------------------------------------*
FORM frm_fill_cell.
  PERFORM: do_fill_cell USING 2 1 '9001',
           do_fill_cell USING 2 2 'Stone',
           do_fill_cell USING 2 3 'Wang',
           do_fill_cell USING 2 4 'Male'.
ENDFORM.                    "fill_cell



*&---------------------------------------------------------------------*
*&      Form  save_excel
*&---------------------------------------------------------------------*
FORM frm_save_excel.
  GET PROPERTY OF excelapp 'ActiveSheet' = sheet. " 获取活动SHEET

  GET PROPERTY OF excelapp 'ActiveWorkbook' = workbook.
  CALL METHOD OF workbook 'SAVE'.

  " 如果要显示Excel
  " SET PROPERTY OF EXCELAPP 'Visible' = 1.

  "直接关闭
  CALL METHOD OF workbook 'CLOSE'.
  CALL METHOD OF excelapp 'QUIT'.

  FREE OBJECT sheet.
  FREE OBJECT workbooks.
  FREE OBJECT workbook.
  FREE OBJECT excelapp.
ENDFORM.                    "save_book