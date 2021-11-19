*&---------------------------------------------------------------------*
*& Report  Z_FILE_DIALOG
*&
*&---------------------------------------------------------------------*

REPORT  z_file_dialog.

PARAMETERS: p_file TYPE localfile OBLIGATORY DEFAULT 'D:\test.txt'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM frm_get_filepath USING p_file.

START-OF-SELECTION.
  IF NOT p_file = ''.
    WRITE: 'File name', p_file.
  ELSE.
    WRITE: 'Errors occured'.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  frm_get_filepath
*&---------------------------------------------------------------------*
FORM frm_get_filepath USING p_fname TYPE localfile.
  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_path         = 'D:/' " default path
      mask             = ',Text Files(*.txt),*.txt,All Files(*.*),*.*, '
      mode             = '0'   " 0 for read
    IMPORTING
      filename         = p_fname
    EXCEPTIONS
      inv_winsys       = 1
      no_batch         = 2
      selection_cancel = 3
      selection_error  = 4
      OTHERS           = 5.
ENDFORM.                    "frm_get_filepath