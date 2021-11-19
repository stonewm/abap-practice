REPORT  z_file_dialog.

PARAMETERS: p_file TYPE localfile OBLIGATORY DEFAULT 'D:\test.txt'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM frm_get_filename_on_f4 USING p_file.

START-OF-SELECTION.
  IF NOT p_file = ''.
    WRITE: 'File name', p_file.
  ELSE.
    WRITE: 'Errors occured'.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  frm_get_filename_on_f4
*&---------------------------------------------------------------------*
FORM frm_get_filename_on_f4 USING p_fname TYPE localfile.
  CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
    EXPORTING
      static    = ' '
      mask      = p_fname
    CHANGING
      file_name = p_fname.
ENDFORM.                    "frm_get_filename_on_f4