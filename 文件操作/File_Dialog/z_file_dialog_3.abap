*&---------------------------------------------------------------------*
*& Report  Z_FILE_DIALOG
*&
*&---------------------------------------------------------------------*


REPORT  z_file_dialog.

PARAMETERS: p_file TYPE localfile OBLIGATORY DEFAULT 'D:\test.txt'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM frm_get_filepath_new USING p_file.

START-OF-SELECTION.
  IF NOT p_file = ''.
    WRITE: 'File name', p_file.
  ELSE.
    WRITE: 'Errors occured'.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  frm_get_filepath_new
*&---------------------------------------------------------------------*
FORM frm_get_filepath_new USING p_fname TYPE localfile.

  DATA: lt_files TYPE filetable,          " 存放文件名的内表
        ls_file  TYPE LINE OF filetable,
        l_subrc LIKE sy-subrc.          " return code


  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title            = 'Please select a file'
      initial_directory       = 'D:/'
    CHANGING
      file_table              = lt_files
      rc                      = l_subrc
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.

  IF sy-subrc IS INITIAL AND l_subrc = 1.
    LOOP AT lt_files INTO ls_file.
      p_fname = ls_file.
    ENDLOOP.
  ENDIF.
ENDFORM.                    "frm_get_filepath_new