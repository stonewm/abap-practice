*&---------------------------------------------------------------------*
*& Report  Z_FILE_DIALOG
*&
*&---------------------------------------------------------------------*


REPORT  z_file_dialog.

PARAMETERS: p_file TYPE localfile OBLIGATORY DEFAULT 'D:\test.txt'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = p_file.

START-OF-SELECTION.
  IF NOT p_file = ''.
    WRITE: 'File name', p_file.
  ELSE.
    WRITE: 'Errors occured'.
  ENDIF.